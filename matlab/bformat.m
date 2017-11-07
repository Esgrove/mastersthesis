%% B-format Processing
% Juri Lukkarila

%% Cafe
% read 9-channel audiofile and export each channel to a separate file
for s = 1:6

    [channels, Fs] = audioread(strcat('espa_', int2str(s),'.wav'));

    for n = 1:9
        x = channels(:,n);

        audiowrite(strcat('export/street_',int2str(s),'_channel_',int2str(n),'.wav'), ...
            x, Fs,'BitsPerSample',16);
    end
end

%% Cafe Re-pack
% Read back edited channels and pack to one 9-channel file again

info = audioinfo('editoidut/cafe_1.wav');

N  = info.TotalSamples;
Fs = info.SampleRate;

cafe = zeros(N, 9);

for n = 1:9
    [x, Fs] = audioread(strcat('editoidut/cafe_',int2str(n),'.wav'));
    
    cafe(:,n) = x;
end

audiowrite('cafe_loop.wav', cafe, Fs, 'BitsPerSample', 16);

%% Street
% read 9-channel audiofile and export each channel to a separate file
for s = 1:9

    [channels, Fs] = audioread(strcat('bule_', int2str(s),'.wav'));

    for n = 1:9
        x = channels(:,n);

        audiowrite(strcat('export/cafe_channel_',int2str(n),'_',int2str(s),'.wav'), ...
            x, Fs,'BitsPerSample',16);
    end
end

%% Street Re-pack
% Read back edited channels and pack to one 9-channel file again

info = audioinfo('editoidut/street_1.wav');

N  = info.TotalSamples;
Fs = info.SampleRate;

street = zeros(N, 9);

for n = 1:9
    [x, Fs] = audioread(strcat('editoidut/street_',int2str(n),'.wav'));
    
    street(:,n) = x;
end

audiowrite('street_loop.wav', street, Fs, 'BitsPerSample', 16);