%% Conversation Assistant: User Test Results
%  Juri Lukkarila
%  2017

% figure settings
screen = get(0,'screensize'); 
figx = 800; figy = 500;
pos = [screen(3)/2-figx/2, screen(4)/2-figy/2, figx, figy]; 

small_pos  = [-0.6 0.1 12 8]; 
small_size = [10.8 7.9];

pie_pos  = [-1.36 -0.4 10 7]; 
pie_size = [7.6 6.3];

big_pos    = [-1.6 0.1 20 9]; 
big_size   = [17.3 9];

%% Import data from CSV file

% questions with two choices
T1 = readtable('numbers1.csv','ReadRowNames',true);

% question with scale 1-7
T2 = readtable('numbers2.csv','ReadRowNames',true);

% questions with six choices
T3 = readtable('numbers3.csv','ReadRowNames',true);

%% Analysis

T1.Avg      = mean(T1{:,:},2);
T1.Avg(end) = mean(T1{end,1:8},2);
T2.Avg      = mean(T2{:,:},2);
T3.Avg      = round(mean(T3{:,:},2));

T1.Percent  = round(T1.Avg.*100);
T2.Percent  = round(T2.Avg.*100./7);

T2.Med      = median(T2{:,1:9},2);
T3.Med      = median(T3{:,1:9},2);

T2.Mode     = mode(T2{:,1:9},2);

%% Answers

for n = 1:14
    figure('Position', pos); 
    bar(T2{n,1:9}, 0.5); hold on;
    axis([-1 11 0 8]);
    set(gca,'YTick',1:7);
    set(gca,'XTick',1:9);
    set(gca,'XTickLabel',{'P1','P2','P3','P4','P5','P6','P7','P8','P9'});
    set(gca,'YGrid','on');
    ylabel('Rating');
    xlabel('Test participant');
    %mline = refline([0 T2.Med(n)]);
    %mline.LineWidth = 0.8; mline.Color = [0.5 0.5 0.5];
    %aline = refline([0 T2.Avg(n)]);
    %aline.LineWidth = 1; aline.Color = 'r';
    %bar(T2{n,1:9}, 0.5);
    %xlabel('participant');
    %ylabel('rating');
    %text(-0.6, T2.Avg(n)+0.3, num2str(round(T2.Avg(n),2)), 'FontSize', 11);
    %text( 9.7, T2.Avg(n)+0.3, strcat(num2str(round(T2.Percent(n),2)),'%'),...
    %'FontSize', 11);
    set(gcf,'PaperUnits','centimeters',...
            'PaperPosition', small_pos,...
            'PaperSize',     small_size);
    print(gcf, strcat('.\figures\T2_',int2str(n)), '-dpdf', '-painters'); 
    pause(1); % java breaks otherwise...
end

%% Histogram

for n = 1:4
    x = hist(T2{n,1:9},[1 2 3 4 5 6 7]);
    figure('Position', pos);
    bar(x, 0.5);
    axis([0 8 0 6]);
    set(gca,'YTick',0:6);
    set(gca,'XTick',1:7);
    set(gca,'YGrid','on');
    ylabel('Number of ratings');
    xlabel('Rating');
    set(gcf,'PaperUnits','centimeters',...
            'PaperPosition', small_pos,...
            'PaperSize',     small_size);
    print(gcf, strcat('.\figures\T2_hist_',int2str(n)), '-dpdf', '-painters'); 
    pause(1); % java breaks otherwise...
end

%% Boxplot

% introduction
figure('Position', pos); 
h = boxplot(T2{1:1,1:9}'); 
set(h,'LineWidth',0.7);
axis([0.5 1.5 0.5 7.5]);
set(gca,'YTick',1:7);
set(gca,'XTick',1:1);
ylabel('Rating');
xlabel('Question');
set(gca,'XTickLabel',{'Q10'});
set(gca,'YGrid','on');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', big_pos,...
        'PaperSize',     big_size);
print(gcf, '.\figures\T2_box1', '-dpdf', '-painters'); 

% section 1
figure('Position', pos); 
h = boxplot(T2{2:6,1:9}'); 
set(h,'LineWidth',0.7);
axis([0.5 5.5 0.5 7.5]);
set(gca,'YTick',1:7);
set(gca,'XTick',1:6);
set(gca,'XTickLabel',{'Q11','Q12','Q13','Q14','Q15'});
ylabel('Rating');
xlabel('Question');
set(gca,'YGrid','on');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', big_pos,...
        'PaperSize',     big_size);
print(gcf, '.\figures\T2_box2', '-dpdf', '-painters'); 

% section 2
figure('Position', pos); 
h = boxplot(T2{7:12,1:9}');
set(h,'LineWidth',0.7);
axis([0.5 6.5 0.5 7.5]);
set(gca,'YTick',1:7);
set(gca,'XTick',1:6);
set(gca,'XTickLabel',{'Q16','Q17','Q18','Q19','Q20','Q21'});
ylabel('Rating');
xlabel('Question');
set(gca,'YGrid','on');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', big_pos,...
        'PaperSize',     big_size);
print(gcf, '.\figures\T2_box3', '-dpdf', '-painters'); 

% debrief
figure('Position', pos); 
h = boxplot(T2{13:end,1:9}');
set(h,'LineWidth',0.7);
axis([0.5 2.5 0.5 7.5]);
set(gca,'YTick',1:7);
set(gca,'XTick',1:8);
set(gca,'XTickLabel',{'Q22','Q24'});
ylabel('Rating');
xlabel('Question');
set(gca,'YGrid','on');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', big_pos,...
        'PaperSize',     big_size);
print(gcf, '.\figures\T2_box4', '-dpdf', '-painters'); 
%%
% Price
figure('Position', pos); 
h = boxplot(T3{1:end,1:9}'); 
set(h,'LineWidth',0.7);
axis([0.5 2.5 0.5 6.5]);
ylabel('Price in euros');
xlabel('Payment type');
set(gca,'YTick',1:6);
set(gca,'YTickLabel',{'0','1-5','5-10','10-20','20-30','+30'});
set(gca,'XTick',1:2);
set(gca,'XTickLabel',{'monthly','one-time'});
set(gca,'YGrid','on');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', [-1.4 0.1 20 9],...
        'PaperSize',     [17.3 9]);
print(gcf, '.\figures\T2_box5', '-dpdf', '-painters');

%% Pie
% T1 & T3

map = [0 0.4470 0.7410 ; 0.8500 0.3250 0.0980]; % colors

lw = 0.8;

figure('Position', pos); 
h = pie(hist(T1{1,1:9},unique(T1{1,1:9}))); colormap([0 0.4470 0.7410]); 
set(h,'LineWidth',lw);
set(findall(gcf,'-property','FontSize'),'FontSize',11)
text(0, -0.3, 'yes', 'FontSize', 14, 'HorizontalAlignment','center');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pie_pos,...
        'PaperSize',     pie_size);
print(gcf, '.\figures\T1_1', '-dpng', '-r600');  

figure('Position', pos); 
h = pie(fliplr(hist(T1{2,1:9},unique(T1{2,1:9})))); colormap(map);
set(h,'LineWidth',lw);
set(findall(gcf,'-property','FontSize'),'FontSize',11)
text(-0.6, -0.1, 'yes', 'FontSize', 14);
text( 0.4, 0.1,  'no', 'FontSize', 14);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pie_pos,...
        'PaperSize',     pie_size);
print(gcf, '.\figures\T1_2', '-dpng', '-r600'); 

figure('Position', pos); 
h = pie(fliplr(hist(T1{3,1:9},unique(T1{3,1:9})))); colormap(map);
set(h,'LineWidth',lw);
set(findall(gcf,'-property','FontSize'),'FontSize',11)
text(-0.6, 0.3, 'yes', 'FontSize', 14);
text( 0.3, -0.25,  'no', 'FontSize', 14);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pie_pos,...
        'PaperSize',     pie_size);
print(gcf, '.\figures\T1_3', '-dpng', '-r600');

figure('Position', pos); 
h = pie(fliplr(hist(T1{4,1:8},unique(T1{4,1:8})))); colormap(map); 
set(h,'LineWidth',lw);
set(findall(gcf,'-property','FontSize'),'FontSize',11)
text(-0.75, 0.45, 'monthly', 'FontSize', 12);
text( 0.05,-0.3, 'one-time', 'FontSize', 12);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', pie_pos,...
        'PaperSize',     pie_size);
print(gcf, '.\figures\T1_4', '-dpng', '-r600'); 

%% Presentation

r1 =  [T2{2:3,1:9} ; T2{5:6,1:9}];
r2 =  [T2{7:8,1:9} ; T2{11:12,1:9}];
r3 =  T2{13:13,1:9};

% section 1
figure('Position', pos); 
h = boxplot(flip(r1,1)', 'orientation', 'horizontal'); 
set(h,'LineWidth',0.7);
axis([0.5 7.5 0.5 4.5]);
set(gca,'XTick',1:7);
set(gca,'YTick',1:4);
set(gca,'YTickLabel',{'4','3','2','1'});
xlabel('Rating');
title('Section 1');
set(gca,'XGrid','on');
%print(gcf, '.\figures\r1', '-dpng'); 

% section 2
figure('Position', pos); 
h = boxplot(flip(r2,1)', 'orientation', 'horizontal');
set(h,'LineWidth',0.7);
axis([0.5 7.5 0.5 4.5]);
set(gca,'XTick',1:7);
set(gca,'YTick',1:4);
set(gca,'YTickLabel',{'4','3','2','1'});
xlabel('Rating');
title('Section 2');
set(gca,'XGrid','on');
%print(gcf, '.\figures\r2', '-dpng'); 

% debrief
figure('Position', pos); 
h = boxplot(r3', 'orientation', 'horizontal');
set(h,'LineWidth',0.7);
axis([0.5 7.5 0.5 1.5]);
set(gca,'XTick',1:7);
xlabel('Rating');
title('Debriefing');
set(gca,'XGrid','on');
%print(gcf, '.\figures\r3', '-dpng'); 

%% Comparison

r1 =  [T2{2:6,1:9}];
r2 =  [T2{7:9,1:9} ; T2{11:12,1:9}];

figure('Position', pos); 
axis([-inf inf 0.5 7.5]);
h = boxplot([r1 ; r2]', {{'1' '2' '3' '4' '5' '1' '2' '3' '4' '5'},...
    {'Q11','Q12','Q13','Q14','Q15','Q16','Q17','Q18','Q20','Q21'}},...
    'Labels',{'Q11','Q16','Q12','Q17','Q13','Q18','Q14','Q20','Q15','Q21'},...
    'factorsep',1,'factorgap',2);
set(h,'LineWidth',0.7);
ylabel('Rating');
set(gca,'YGrid','on');
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', big_pos,...
        'PaperSize',     big_size);
print(gcf, '.\figures\comparison', '-dpdf', '-painters'); 

%% end
close all;