#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright (c) 2017 Juri Lukkarila 
# Copyright (c) 2013 Tanel Alumae
# Copyright (c) 2008 Carnegie Mellon University.
#
# Inspired by the CMU Sphinx's Pocketsphinx Gstreamer plugin demo (which has BSD license)
#
# Licence: BSD

import sys
import os
import gi
gi.require_version('Gst', '1.0')
gi.require_version('Gtk', '3.0')
from gi.repository import GObject, Gst, Gtk, Gdk, Pango
GObject.threads_init()
Gdk.threads_init()

Gst.init(None)

class DemoApp(object):

    def __init__(self):

        self.init_gui()
        self.init_gst()

    def init_gui(self):

        self.window = Gtk.Window()
        self.window.connect("destroy", self.quit)
        self.window.set_default_size(800, 1000)
        self.window.set_border_width(10)
        self.window.set_title("KESKUSTELUAVUSTIN")

        # layout 
        vbox = Gtk.VBox()

        # partial result text view
        self.text_partial = Gtk.TextView()
        self.text_partial.override_font(Pango.FontDescription("DejaVu Sans Mono 20"))
        self.textbuf_partial = self.text_partial.get_buffer()
        self.text_partial.set_wrap_mode(Gtk.WrapMode.WORD)
        self.text_partial.set_cursor_visible(False)

        # scrolling window for final result
        self.scrolled = Gtk.ScrolledWindow()

        # final result text view
        self.text_final = Gtk.TextView()
        self.text_final.override_font(Pango.FontDescription("DejaVu Sans Mono 20"))
        self.textbuf_final = self.text_final.get_buffer()
        self.text_final.set_wrap_mode(Gtk.WrapMode.WORD)
        self.text_final.set_cursor_visible(False)

        self.scrolled.add(self.text_final)
        
        # button
        self.button = Gtk.Button("Puhu")
        self.button.connect('clicked', self.button_clicked)
        
        vbox.pack_start(self.scrolled, True, True, 4)
        vbox.pack_start(self.text_partial, False, False, 1)
        vbox.pack_start(self.button, False, False, 8)

        self.window.add(vbox)
        self.window.show_all()

    def quit(self, window):
        Gtk.main_quit()

    def init_gst(self):

        self.pulsesrc = Gst.ElementFactory.make("pulsesrc", "pulsesrc")

        if self.pulsesrc == None:
            print >> sys.stderr, "Error loading pulsesrc GST plugin. You need the gstreamer1.0-pulseaudio package"
            sys.exit()
        
        # TODO: get audio level and ignore input below threshold!
        self.level = Gst.ElementFactory.make("level", "level")

        self.audioconvert  = Gst.ElementFactory.make("audioconvert", "audioconvert")
        self.audioresample = Gst.ElementFactory.make("audioresample", "audioresample")
        self.asr           = Gst.ElementFactory.make("kaldinnet2onlinedecoder", "asr")
        self.fakesink      = Gst.ElementFactory.make("fakesink", "fakesink")

        if self.asr:
            model_file = "final.mdl"
            if not os.path.isfile(model_file):
                print >> sys.stderr, "Model Not Found"
                sys.exit(1)
            self.asr.set_property("use-threaded-decoder", True)
            self.asr.set_property("acoustic-scale", 0.09)
            self.asr.set_property("beam", 10.0)
            self.asr.set_property("lattice-beam", 6.0)
            self.asr.set_property("max-active", 10000)
            self.asr.set_property("model", "final.mdl")
            self.asr.set_property("fst", "graph_finnish_morph_5gram/HCLG.fst")
            self.asr.set_property("word-syms", "graph_finnish_morph_5gram/words.txt")
            self.asr.set_property("feature-type", "mfcc")
            self.asr.set_property("mfcc-config", "conf/mfcc.conf")
            self.asr.set_property("ivector-extraction-config", "conf/ivector_extractor.conf")
            self.asr.set_property("do-endpointing", True)
            self.asr.set_property("endpoint-silence-phones", "1:2:3:4:5")
            self.asr.set_property("chunk-length-in-secs", 0.2)

        else:
            print >> sys.stderr, "Couldn't create the kaldinnet2onlinedecoder element. "
            if os.environ.has_key("GST_PLUGIN_PATH"):
                print >> sys.stderr, "Have you compiled the Kaldi GStreamer plugin?"
            else:
                print >> sys.stderr, "You probably need to set the GST_PLUGIN_PATH envoronment variable"
                print >> sys.stderr, "Try running: GST_PLUGIN_PATH=../src %s" % sys.argv[0]
            sys.exit()

        # initially silence the decoder
        self.asr.set_property("silent", True)

        self.pipeline = Gst.Pipeline()
        for element in [self.pulsesrc, self.audioconvert, self.audioresample, self.asr, self.fakesink]:
            self.pipeline.add(element)
        self.pulsesrc.link(self.audioconvert)
        self.audioconvert.link(self.audioresample)
        self.audioresample.link(self.asr)
        self.asr.link(self.fakesink)

        self.asr.connect('partial-result', self._on_partial_result)
        self.asr.connect('final-result', self._on_final_result)
        self.pipeline.set_state(Gst.State.PLAYING)

    def _on_partial_result(self, asr, hyp):
        """Delete any previous selection, insert text and select it."""
        Gdk.threads_enter()
        # All this stuff appears as one single action
        self.textbuf_partial.begin_user_action()

        self.textbuf_partial.delete_selection(True, self.text_partial.get_editable())

        new_text = hyp.replace("+ +", "").replace("+", "")
        if (len(new_text) > 1):

            #print(new_text)
            if (hyp[0] is "+"):
            	# go back one char
                ins = self.textbuf_partial.get_cursor()
                iter = self.textbuf_partial.get_iter_at_mark(ins)
                iter.backward_chars(1)
                self.textbuf_partial.move_mark(ins, iter)

            self.textbuf_partial.insert_at_cursor(new_text)
            ins = self.textbuf_partial.get_insert()
            iter = self.textbuf_partial.get_iter_at_mark(ins)
            iter.backward_chars(len(new_text))
            self.textbuf_partial.move_mark(ins, iter)

        self.textbuf_partial.end_user_action()
        Gdk.threads_leave()

    def _on_final_result(self, asr, hyp):
        Gdk.threads_enter()
        """Insert the final result."""
        # All this stuff appears as one single action
        self.textbuf_final.begin_user_action()
        self.textbuf_partial.begin_user_action()
        if (len(hyp) > 1):
            self.textbuf_partial.delete(self.textbuf_partial.get_start_iter(), self.textbuf_partial.get_end_iter())
            new_text = hyp.replace("+ +", "").replace("+","")
            self.textbuf_final.insert_at_cursor(new_text)
            self.textbuf_final.insert_at_cursor("\n\n")

            self.text_final.scroll_mark_onscreen(self.textbuf_final.get_insert())

        self.textbuf_partial.end_user_action()
        self.textbuf_final.end_user_action()
        Gdk.threads_leave()

    def button_clicked(self, button):

        if button.get_label() == "Puhu":
            button.set_label("Pysäytä")
            self.asr.set_property("silent", False)
        else:
            button.set_label("Puhu")
            self.asr.set_property("silent", True)
            
if __name__ == '__main__':
    app = DemoApp()
    Gdk.threads_enter()
    Gtk.main()
    Gdk.threads_leave()
