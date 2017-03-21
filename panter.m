clear all; close all; clc;

vertical = true; %vertikalni modul
horizontal = true; %horizontalni modul
data_type = 'm'; % m (matrix) / c (columns)
%data_type = columns;

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

switch data_type
    case 'c'
        data = fitsread([path,file],'primary'); 
        image = zeros();
        for i=1:size(data,1)
            image(data(i,1),data(i,2)) = data(i,3);
        end
    case 'm'
        image = fitsread([path,file],'primary'); 
end

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
xlabel('x (mm)'); 
ylabel('y (mm)'); 

%% rezy
if (horizontal || vertical)
    figure(3);
    imagesc(image_roi);
    set(gcf,'Name','Oznac misto rezu (1 bod)'); 
    [x_p,y_p] = ginput(1); 
    x_p = round(x_p); 
    y_p = round(y_p);

    FWHM_x = 0;
    FWHM_x_gauss = 0;
    FWHM_y = 0;
    FWHM_y_gauss = 0;

    if vertical %horizontalni rez
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
    end

    if horizontal %vertikalni rez
        sect_ver = image_roi(:,x_p); 
        oblast = find(sect_ver > 0.5*max(sect_ver)); 
        FWHM_y = pixum/1000*(oblast(end)-oblast(1));

        figure(8); 
        [FitResults,LowestError,baseline,BestStart,xi,yi,residual] = peakfit([y' sect_ver]);
        FWHM_y_gauss = FitResults(4);

        figure(9); 
        plot(y,sect_ver); 
        line(xi,yi,'Color','red','LineWidth',2);
        xlabel('y (mm)'); 
        ylabel('Counts (-)'); 
        title(['FWHM = ',num2str(round(FWHM_y*100)/100),' mm (data) / ',num2str(round(FWHM_y_gauss*100)/100),' mm (gaussfit)']);
    end

    % zapis vysledku do souboru
    vysl = fopen('results.txt','a'); 
    fprintf(vysl,'%s\t%s\t%g\t%g\t%g\t%g\n',path,mirror,FWHM_x,FWHM_x_gauss,FWHM_y,FWHM_y_gauss);
    fclose('all');
end

%% ulozeni obrazku
save_name = [path,mirror,'_',name];

figure(2); 
print(gcf,'-dpng','-r600',[save_name,'.png']);
saveas(gcf,[save_name,'.fig'],'fig');

if vertical
    figure(7); 
    print(gcf,'-dpng','-r600',[save_name,'_h-sect.png']);
    saveas(gcf,[save_name,'_h-sect.fig'],'fig');
end

if horizontal
    figure(9); 
    print(gcf,'-dpng','-r600',[save_name,'_v-sect.png']);
    saveas(gcf,[save_name,'_v_sect.fig'],'fig');
end