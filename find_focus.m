clear all; close all; clc;

px = 0.075;
z0 = 6335;
z = -250:100:250;
FWHM_x = px*[47.368 37.387 38.289 34.335 24.817 22.753];
FWHM_y = px*[37.688 39.681 46.174 48.971 51.445 56.432];

%%
figure(1);
hold on;
grid on;
grid minor;
plot(z,FWHM_x,'.--','Color','red','LineWidth',1,'MarkerSize',15);
plot(z,FWHM_y,'.--','Color','b','LineWidth',1,'MarkerSize',15);
legend('1D vertical','1D horizontal');
xlim([-300 300]);
ylim([0 6]);
xlabel('z shift (mm)');
ylabel('FWHM (mm)');

figure(2);
hold on;
grid on;
grid minor;
plot(z+z0,FWHM_x,'.--','Color','red','LineWidth',1,'MarkerSize',15);
plot(z+z0,FWHM_y,'.--','Color','b','LineWidth',1,'MarkerSize',15);
legend('1D vertical','1D horizontal');
%xlim([-300 300]);
ylim([0 6]);
xlabel('focal length (mm)');
ylabel('FWHM (mm)');

%%
figure(1); print(gcf,'-dpng','-r600','../2017-03-20_FWHM(z-shift).png');
figure(2); print(gcf,'-dpng','-r600','../2017-03-20_FWHM(focal-length).png');
