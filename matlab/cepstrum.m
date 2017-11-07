%% Cepstrum
%  Juri Lukkarila
%  2017

screen = get(0,'screensize'); 

% read audio
[x, Fs] = audioread('kaakko.wav'); % /a/

% normalize
xmin = min(x);
xmax = max(x);
if abs(xmin) >= xmax
    x = x./abs(xmin);
else
    x = x./xmax;
end

% figure for determining a starting index for a 30 ms frame
%figure('OuterPosition',[0, 0, screen(3), screen(4)]); % fullscreen
%plot((0:1:length(x)-1)./Fs, x); xlabel('Time (s)');

% segment
index1 = 2531;
index2 = index1 + 0.03*Fs - 1;  % 30 ms

x = x(index1:index2);           % set 30 ms frame
N = length(x);                  % samples
Ts = 1/Fs;                      % sample time 
t = 0:Ts:(N-1)*Ts;              % time vector

% hamming window
x = hamming(N) * x; 

% cepstrum
xhat = rceps(x);

% samples
N = length(xhat);

% take half
xhat_lifter = xhat(1:N/2); 

% apply rectangular window
xhat_lifter(85:end) = 0;

% FFT
nfft  = 2^nextpow2(Fs);                   % fft points

Xhatf = abs(fft(xhat_lifter,nfft)); 

f0 = Fs/nfft;                             % frequency resolution (Hz)
f  = 0:f0:(nfft-1)*f0;                    % frequency vector
index = find(f >= Fs/2, 1);               % index for freq Fs/2x

Xhatf = Xhatf(1:index); f = f(1:index);   % drop values over Fs/2

% plot
figure('Position',[screen(3)/2-600, screen(4)/2-300, 1200, 600]);
plot(f, Xhatf,'linewidth', 0.3); grid on; hold on;

w = [48 12];
for n = 1:2
    Xhatf = abs(fft(xhat(1:w(n)),nfft)); % fft
    f0    = Fs/nfft;                            % frequency resolution (Hz)
    f     = 0:f0:(nfft-1)*f0;                   % frequency vector
    index = find(f >= Fs/2, 1);                 % index for freq Fs/2x
    Xhatf = Xhatf(1:index); f = f(1:index);     % drop values over Fs/2
    plot(f, Xhatf,'linewidth', 0.3 + n*0.3);
end

legend('84','48','12');
ylabel('Magnitude');
xlabel('Frequency (Hz)');
axis([0 4000 -0.1 2.1]);
set(gca,'YTick', 0:0.5:2);
set(gca,'XTick', [0 500 1000 1500 2000 2500 3000 3500 4000]);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', [-1.2 0.1 20 10],...
        'PaperSize',     [17.8 9.9]);
print(gcf, '.\figures\cepstrum', '-dpdf', '-painters');