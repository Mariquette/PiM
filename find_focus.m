clear all; close all; clc;

px = 0.075;
z0 = 6335;
z = -250:100:250;
FWHM_2DH = px*[47.368 37.387 38.289 34.335 24.817 22.753];
FWHM_2DV = px*[37.688 39.681 46.174 48.971 51.445 56.432];
FWHM_1D = px*[31.391 24.696 24.443 27.418 35.219 44.206];

%%
figure(1);
hold on;
grid on;
grid minor;
plot(z,FWHM_2DH,'.--','Color','r','LineWidth',1,'MarkerSize',15);
plot(z,FWHM_2DV,'.--','Color','b','LineWidth',1,'MarkerSize',15);
%plot(z,FWHM_1D,'.-','Color','g','LineWidth',1,'MarkerSize',15);
plot(z,FWHM_1D,'.-','LineWidth',1,'MarkerSize',15);
legend('2D horizontal','2D vertical','1D');
xlim([-300 300]);
ylim([0 6]);
xlabel('z shift (mm)');
ylabel('FWHM (mm)');

figure(2);
hold on;
grid on;
grid minor;
plot(z+z0,FWHM_2DH,'.--','Color','r','LineWidth',1,'MarkerSize',15);
plot(z+z0,FWHM_2DV,'.--','Color','b','LineWidth',1,'MarkerSize',15);
%plot(z+z0,FWHM_1D,'.-','Color','g','LineWidth',1,'MarkerSize',15);
plot(z+z0,FWHM_1D,'.-','LineWidth',1,'MarkerSize',15);
legend('2D horizontal','2D vertical','1D');
xlim([6050 6650]);
ylim([0 6]);
xlabel('focal length (mm)');
ylabel('FWHM (mm)');

%%
figure(1); print(gcf,'-dpng','-r600','../2017-03-20_FWHM(z-shift).png');
figure(2); print(gcf,'-dpng','-r600','../2017-03-20_FWHM(focal-length).png');
