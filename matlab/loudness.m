%% Equal-loudness Contour ISO 226:2003
%  Juri Lukkarila
%  2017

% figure size settings
screen = get(0,'screensize'); 
figx = 840; figy = 500;
pos = [screen(3)-figx, screen(4)-figy, figx, figy];

figure('Position', pos);

for p = 0:20:80
    % curve data
    [SPL, F] = iosr.auditory.iso226(p); 
    
    % plot
    semilogx(interp(F,4),interp(SPL,4),'-r','LineWidth',0.7);
    text(1000,p+6,int2str(p),'FontSize', 11,'HorizontalAlignment','center'); 
    
    hold on; 
end

grid on;
axis([17 16000 -15 125]);  
xlabel('Frequency (Hz)'); 
ylabel('SPL (dB)');

set(gca,'XScale','log');
set(gca,'XTick',     [20 31.5 63 125 250 500 1000 2000 4000 8000 16000]);
set(gca,'XTickLabel',{20 31.5 63 125 250 500 '1k' '2k' '4k' '8k' '16k'});
set(gca,'XMinorTick','off'); 
set(gca,'XMinorGrid','off');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', [-1.2 0.1 20 10],...
        'PaperSize',     [17.8 9.9]);
print(gcf, '.\figures\loudness', '-dpdf', '-painters');