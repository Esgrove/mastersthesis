%% Mel-Scale Filter Bank
%  Juri Lukkarila
%  2017

screen = get(0,'screensize'); 

% mel filter bank
n  = 12; % filters
f  = linspace(0, 4000, 100000); % need a very large matrix to get nice lines for figure 
mf = 2595 * log10(1 + f/700); % Convert to Mel scale

MinF = min(mf);
MaxF = max(mf); 
MelBinWidth = (MaxF - MinF)/(n+1);

melfilter = zeros(n, length(mf));
for i = 1:n
    % find window start and end point
    filt = find(mf >= ((i-1) * MelBinWidth + MinF) & ...
                mf <= ((i+1) * MelBinWidth + MinF));
    % triangle window        
    melfilter(i, filt) = triang(length(filt)); 
end
melfilter = sparse(melfilter); % don't store all the zeroes...

figure('Position', [screen(3)/2-500, screen(4)/2-300, 1000, 600]);

plot(f, melfilter, 'LineWidth', 0.6); grid on; hold on;
plot([0 4000],[0 0],'Color','black','LineWidth', 0.8);

% set limits and labels
set(gca,'xlim',[0 4000]);
xlabel('Frequency (Hz)')
axis([0 4000 0 1.05]);
set(gca,'XTick', [0 500 1000 1500 2000 2500 3000 3500 4000]);
set(gca,'YTick', 0:0.25:1);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', [-1.5 0 20 10],... 
        'PaperSize',     [17.6 10]);
print(gcf, '.\figures\melfilter', '-dpdf', '-painters');