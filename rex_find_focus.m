clear all; close all; clc;

z0 = 6335;
z = [0 5 10 12.5 15 20 25];
results = uiimport;
results = results.data;

%%
figure(1);

subplot(2,1,1);
hold on;
grid on;
grid minor;
plot(z,results(:,1),'.-','Color','b','LineWidth',1,'MarkerSize',15);
plot(z,results(:,2),'.--','Color','b','LineWidth',1,'MarkerSize',15);
plot(z,results(:,5),'.-','Color','r','LineWidth',1,'MarkerSize',15);
plot(z,results(:,6),'.--','Color','r','LineWidth',1,'MarkerSize',15);
title('Horizontal FWHM');
legend('cross section (data)','cross section (gaussfit)','sum (data)','sum (gaussfit)','Location','northeastoutside');
xlabel('z shift (mm)');
ylabel('FWHM (mm)');
ylim([0 3]);

subplot(2,1,2);
hold on;
grid on;
grid minor;
plot(z,results(:,3),'.-','Color','b','LineWidth',1,'MarkerSize',15);
plot(z,results(:,4),'.--','Color','b','LineWidth',1,'MarkerSize',15);
plot(z,results(:,7),'.-','Color','r','LineWidth',1,'MarkerSize',15);
plot(z,results(:,8),'.--','Color','r','LineWidth',1,'MarkerSize',15);
title('Vertical FWHM');
legend('cross section (data)','cross section (gaussfit)','sum (data)','sum (gaussfit)','Location','northeastoutside');
xlabel('z shift (mm)');
ylabel('FWHM (mm)');
ylim([0 3]);

%%
figure(1); 
%set(gcf,'PaperPosition',[0 0.05 15*16 15*9],'PaperSize',[15*16 15*9]);
print(gcf,'-dpng','-r600','../REX_FWHM(z-shift).png');