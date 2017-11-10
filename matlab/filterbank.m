%% Mel-Scale Filter Bank
%  Juri Lukkarila
%  2017

screen = get(0,'screensize'); 
pos    = [-1.2 0 20 9.5]; 
size   = [17.5 9.5];

% mel filter bank
n  = 12; % filters
f  = linspace(0, 4000, 100000); % need a very large matrix to get nice lines for figure 
mf = 2595 * log10(1 + f/700); % Convert to Mel scale

MinF = min(mf);
MaxF = max(mf); 
MelBinWidth = (MaxF - MinF)/(n+1);

% construct filters
melfilter = zeros(n, length(mf));
for i = 1:n
    % find window start and end point
    filt = find(mf >= ((i-1) * MelBinWidth + MinF) & ...
                mf <= ((i+1) * MelBinWidth + MinF));
    % triangle window        
    melfilter(i, filt) = triang(length(filt)); 
end
melfilter(melfilter < 0.00001) = NaN;

% plot
figure('Position', [screen(3)/2-500, screen(4)/2-300, 1000, 600]); 
plot(f, melfilter,'Color',[0 0.4470 0.7410],'LineWidth',0.7); hold on;
%plot([0 4000],[0 0],'Color','black', 'LineWidth',0.7); 
grid on; 
set(gca,'xlim',[0 4000]);
xlabel('Frequency (Hz)')
ylabel('Magnitude');
axis([0 4000 0 1.05]);
set(gca,'XTick', [0 500 1000 1500 2000 2500 3000 3500 4000]);
set(gca,'YTick', 0:0.25:1);
set(gca ,'BoxStyle','full');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pos,...
        'PaperSize',     size);
print(gcf, '.\figures\melfilter', '-dpdf', '-painters');