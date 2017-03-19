clear all; close all; clc;

%% vyber souboru
[file,path] = uigetfile('*.fits','Select file');

%% zjisteni informaci z FITS, nacteni dat
info = fitsinfo([path,file]);
info.PrimaryData.Keywords

date = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'DATE'),2}; %datum
name = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'TITLE'),2}; %nazev
energy = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'XENER'),2}; %energie
mirror = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'MIRROR'),2}; %zrcadlo
pixum = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'PIXUM'),2}; %velikost pixelu [um]
pixas = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'PIXAS'),2}; %velikost pixelu [arcsec]
measurement = info.PrimaryData.Keywords{strcmp(info.PrimaryData.Keywords(),'EXPTYP'),2}; %typ mereni

image = fitsread([path,file],'primary'); 

imagesc(image); 
axis image; 
colorbar;

%% zpracovani
[xx,yy,image_roi] = roi(image);

%% vykresleni
figure(2); 
x = linspace(pixum/1000/2,pixum/1000*length(xx)-pixum/1000/2,length(xx));
y = linspace(pixum/1000/2,pixum/1000*length(yy)-pixum/1000/2,length(yy));
imagesc(x,y,image_roi);
axis image;
colorbar;
colormap jet;
title([date,' ',name,' ',energy,' \newline',mirror,' ',measurement]);
xlabel('Distance (mm)'); 
ylabel('Distance (mm)'); 

%% rezy
figure(3);
imagesc(image_roi);
[x_p,y_p] = ginput(1); 
x_p = round(x_p); 
y_p = round(y_p);

%horizontalni
sect_hor = image_roi(y_p,:); 
oblast = find(sect_hor > 0.5*max(sect_hor)); 
FWHM_x = pixum/1000*(oblast(end)-oblast(1));

figure(6);
[FitResults,LowestError,baseline,BestStart,xi,yi,residual] = peakfit([x' sect_hor']);
FWHM_x_gauss = FitResults(4);

figure(7); 
plot(x,sect_hor); 
line(xi,yi,'Color','red','LineWidth',2);
xlabel('x (mm)'); 
ylabel('Counts (-)'); 
title(['FWHM = ',num2str(round(FWHM_x*100)/100),' mm (data) / ',num2str(round(FWHM_x_gauss*100)/100),' mm (gaussfit)']);

%vertikalni
sect_ver = image_roi(:,x_p); 
oblast = find(sect_ver > 0.5*max(sect_ver)); 
FWHM_y = pixum/1000*(oblast(end)-oblast(1));

figure(8); 
[FitResults,LowestError,baseline,BestStart,xi,yi,residual] = peakfit([y' sect_ver]);
FWHM_y_gauss = FitResults(4);

figure(9); 
plot(y,sect_ver); 
line(xi,yi,'Color','red','LineWidth',2);
xlabel('x (mm)'); 
ylabel('Counts (-)'); 
title(['FWHM = ',num2str(round(FWHM_y*100)/100),' mm (data) / ',num2str(round(FWHM_y_gauss*100)/100),' mm (gaussfit)']);

%% zapis vysledku do souboru
vysl = fopen('../results.txt','a'); 
fprintf(vysl,'%s\t%s\t%g\t%g\t%g\t%g\n',path,mirror,FWHM_x,FWHM_x_gauss,FWHM_y,FWHM_y_gauss);
fclose('all');

%% ulozeni obrazku
save_name = [path,mirror,'_',name];

figure(2); print(gcf,'-dpng','-r600',[save_name,'.png']);
figure(7); print(gcf,'-dpng','-r600',[save_name,'_h-sect.png']);
figure(9); print(gcf,'-dpng','-r600',[save_name,'_v-sect.png']);
