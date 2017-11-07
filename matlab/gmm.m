%% Gaussian Mixture Model
%  Juri Lukkarila
%  2017

% figure settings
screen = get(0,'screensize'); 
figx = 800; figy = 600;
pos = [screen(3)/2-figx/2, screen(4)/2-figy/2, figx, figy]; 

N = 41;
a = linspace(-4,4,N);
b = linspace(-4,4,N*10); % for smooth 1D curves

% Gaussian 1
sx  = 1.2;
x   = 2 / (sqrt(2*pi) * sx) .* exp(-a.^2 / (2 * sx^2));
xb  = 2 / (sqrt(2*pi) * sx) .* exp(-b.^2 / (2 * sx^2));

x  = x  ./ max(xb) * 0.5;
xb = xb ./ max(xb) * 0.5;

% Gaussian 2
y1  = 1 / (sqrt(2*pi) * 1.0) .* exp(-(a+1.0).^2 / (2 * 1.0^2));
y2  = 1 / (sqrt(2*pi) * 0.6) .* exp(-(a-1.6).^2 / (2 * 0.6^2));

y1b = 1 / (sqrt(2*pi) * 1.0) .* exp(-(b+1.0).^2 / (2 * 1.0^2));
y2b = 1 / (sqrt(2*pi) * 0.6) .* exp(-(b-1.6).^2 / (2 * 0.6^2));

y  = y1  + y2;  
yb = y1b + y2b; 

y  = y  ./ max(yb) * 0.5;
yb = yb ./ max(yb) * 0.5;

% 2D grid
[X,Y] = meshgrid(a);

% height over 2D grid
Z = zeros(N,N);
for n = 1:N
    for m = 1:N
        Z(n,m) = x(n) * y(m);
    end
end

% scale
Z = Z ./ max(max(Z)) * 0.5;

figure('Position', pos);
surf(X,Y,Z,'EdgeColor',[0.2 0.2 0.2]); grid on; axis auto; hold on;
plot3(b,4+zeros(1,N*10),yb,'-k','LineWidth',0.8);
plot3(4+zeros(1,N*10),b,xb,'-k','LineWidth',0.8);
axis([-4 4 -4 4 0 0.6]);
view(-45,45);
text(-5.5,-0.5,0,'Y','HorizontalAlignment','center');
text(-0.5,-5.5,0,'X','HorizontalAlignment','center');
zlabel('P');
text(4,0,0.4,'P(b)','HorizontalAlignment','center');
text(0,4,0.4,'P(a)','HorizontalAlignment','center');
load('WhiteToRedMap.mat'); % custom colormap
colormap(mymap);
set(gcf,'PaperUnits','centimeters',...
        'PaperPosition', [-1.2 -0.4 20 14],...
        'PaperSize',     [17.8 13]);
print(gcf, '.\figures\gmm','-dpdf', '-painters');