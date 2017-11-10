%% Audio Signal
%  Juri Lukkarila
%  2017

screen = get(0,'screensize'); 
pos    = [-1.2 0 20 6.8]; 
size   = [17.5 6.8];

% read audio
[x, Fs] = audioread('numerot.wav'); audioinfo('numerot.wav')

% normalize
xmin = min(x);
xmax = max(x);
if abs(xmin) >= xmax
    x = x./abs(xmin);
else
    x = x./xmax;
end
x = 0.95.*x; % scale

N = length(x);            % samples
Ts = 1/Fs;                % sample time 
t = 0:Ts:(N-1)*Ts;        % time vector

%% waveform
figure('Position', [screen(3)/2-500, screen(4)/2-300, 1000, 600]);
plot(t, x); grid on;
axis([0 3 -1 1]);
set(gca,'YTick',[-1 -0.5 0 0.5 1]);
xlabel('Time (s)','FontSize', 10);
%ylabel('Amplitude','FontSize', 10);
set(gca,'fontsize',10);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pos,...
        'PaperSize',     size);
print(gcf, '.\figures\waveform', '-dpdf', '-painters'); 

%% spectrogram
window  = round(0.03*Fs);   % 20 ms window
if mod(window, 2) ~= 0      % if odd
    window = window + 1;    
end
overlap = window/2;         % window overlap
nfft    = 2^16;             % fft points

figure('Position', [screen(3)/2-500, screen(4)/2-300, 1000, 600]);
spectrogram(x, hamming(window), overlap, nfft, Fs,'yaxis','MinThreshold', -85, 'power');
axis([0 3 0 8]);
%set(gca,'YTick',[0.063 0.125 0.25 0.5 1 2 4 8]); 
%set(gca,'YTickLabel',{63 125 250 500 '1k' '2k' '4k' '8k'});
ylabel('Frequency (Hz)','FontSize', 10);
xlabel('Time (s)','FontSize', 10);
axis([0 3 0 8]);
% change colorbar size and location
%c = colorbar; ax = gca; axpos = ax.Position; cpos = c.Position;
%cpos(3) = 0.5*cpos(3); c.Position = cpos; ax.Position = axpos;
%c.Label.String = 'Power (dB)';
colorbar off;
set(gca,'fontsize',10);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pos,...
        'PaperSize',     size);
print(gcf, '.\figures\spectrogram', '-dpdf', '-r600');

%% Together

% figure('Position', [screen(3)/2-500, screen(4)/2-300, 1000, 600]);
% 
% subplot(2,1,1);
% plot(t, x); grid on;
% axis([0 3 -1 1]);
% ylabel('Amplitude');
% xlabel('Time (s)');
% 
% subplot(2,1,2);
% spectrogram(x, hamming(window), overlap, nfft, Fs,'yaxis','MinThreshold',-85,'power');
% axis([0 3 0 8]);
% %set(gca,'YScale','log');
% %axis([0 3 0.063 16]);
% %set(gca,'YTick',[0.063 0.125 0.25 0.5 1 2 4 8 16]); 
% %set(gca,'YTickLabel',{63 125 250 500 '1k' '2k' '4k' '8k' '16k'})
% ylabel('Frequency (Hz)');
% xlabel('Time (s)');
% axis([0 3 0 8]);
% colorbar off;
% grid on;
% set(gcf,'PaperUnits','centimeters',...
%         'PaperPosition', [-1.3 -0.3 20 15],...
%         'PaperSize',     [18 14.5]);
% print(gcf, '.\figures\audio', '-dpdf', '-r1200');