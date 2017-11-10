%% Equal-loudness Contour ISO 226:2003
%  Juri Lukkarila
%  2017

% figure size settings
screen = get(0,'screensize'); 
figx = 840; figy = 500;
pos    = [-1.2 0 20 9.5]; 
size   = [17.5 9.5];

figure('Position', [screen(3)/2-500, screen(4)/2-300, 1000, 600]); 

for p = 0:20:80
    % curve data
    [SPL, F] = iosr.auditory.iso226(p); 
    
    % plot
    semilogx(interp(F,4),interp(SPL,4),'Color',[0 0.4470 0.7410],'LineWidth',0.7);
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
        'PaperPosition', pos,...
        'PaperSize',     size);
print(gcf, '.\figures\loudness', '-dpdf', '-painters');