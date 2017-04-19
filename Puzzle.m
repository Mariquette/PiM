close all
clear all
clc

%% Initialization ....
overlay_step = 2666; %prekryv pocet kroku
dimension = 3;  %dimenze vysledne matice
px = 55;        %velikost pixelu [um]
px_num = 256;   %pocet pixelu 
filter = true;  %filtrovat?


shift = 795*(tan(deg2rad((0.9/3600)*overlay_step)));    %posun v mm
overlay_px=ceil(px_num-(shift*1000/px));                      %prekryv v px

merge_fig = zeros((px_num*dimension)-((dimension-1)*ceil(overlay_px)));        %vysledna nefil. matice
merge_fig_fil = zeros((px_num*dimension)-((dimension-1)*ceil(overlay_px)));    %vysledna filtrovana matice

images_pos1 = zeros(px_num);
images_pos1_fil = zeros(px_num);
images_pos2 = zeros(px_num);
images_pos2_fil = zeros(px_num);
images_pos4 = zeros(px_num);
images_pos4_fil = zeros(px_num);
images_pos5 = zeros(px_num);
images_pos5_fil = zeros(px_num);
images_pos6 = zeros(px_num);
images_pos6_fil = zeros(px_num);
images_pos8 = zeros(px_num);
images_pos8_fil = zeros(px_num);
%%  Loading ...
folder_cal = '.\Calib\Risesat_225_calib_FITPIX_3_0_sn_0001';
folder_pos1 = '.\Data\panter\z000_ToT_0s5_Cu_pos1';
folder_pos2 = '.\Data\panter\z000_ToT_0s5_Cu_pos2';
folder_pos4 = '.\Data\panter\z000_ToT_0s5_Cu_pos4';
folder_pos5 = '.\Data\panter\z000_ToT_0s5_Cu_pos5';
folder_pos6 = '.\Data\panter\z000_ToT_0s5_Cu_pos6';
folder_pos8 = '.\Data\panter\z000_ToT_0s5_Cu_pos8';

image_list = dir([folder_pos1, '/*.txt']);
%image_list = dir([folder, '/*image*']);
value = length(image_list); 
%value = 3;

% load calibration matrices    
a = load([folder_cal, '/_Calib_a.txt']);
b = load([folder_cal, '/_Calib_b.txt']);
c = load([folder_cal, '/_Calib_c.txt']);
t = load([folder_cal, '/_Calib_t.txt']);

h = waitbar(0,'Please wait...');

for k=1:value
  %% Loading  ...
  
    name = image_list(k).name;
    image_pos1 = load([folder_pos1,'/',name]);
    image_pos2 = load([folder_pos2,'/',name]);
    image_pos4 = load([folder_pos4,'/',name]);
    image_pos5 = load([folder_pos5,'/',name]);
    image_pos6 = load([folder_pos6,'/',name]);
    image_pos8 = load([folder_pos8,'/',name]); 
 
    %% filtering
    if filter 
        image_pos1_fil = zeros(px_num); 
        image_pos2_fil = zeros(px_num); 
        image_pos4_fil = zeros(px_num); 
        image_pos5_fil = zeros(px_num); 
        image_pos6_fil = zeros(px_num); 
        image_pos8_fil = zeros(px_num); 

        % pos1
        [xx,yy] = find(image_pos1 > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image_pos1,i,j) && ~getPixel(image_pos1,i,j-1) && ~getPixel(image_pos1,i,j+1) && ~getPixel(image_pos1,i+1,j) && ~getPixel(image_pos1,i-1,j) && ~getPixel(image_pos1,i-1,j-1) && ~getPixel(image_pos1,i-1,j+1) && ~getPixel(image_pos1,i+1,j-1) && ~getPixel(image_pos1,i+1,j+1))
               image_pos1_fil(i,j) = image_pos1(i, j);
           else
               image_pos1_fil(i,j) = 0;
           end
        end
        
        % pos2
        [xx,yy] = find(image_pos2 > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image_pos2,i,j) && ~getPixel(image_pos2,i,j-1) && ~getPixel(image_pos2,i,j+1) && ~getPixel(image_pos2,i+1,j) && ~getPixel(image_pos2,i-1,j) && ~getPixel(image_pos2,i-1,j-1) && ~getPixel(image_pos2,i-1,j+1) && ~getPixel(image_pos2,i+1,j-1) && ~getPixel(image_pos2,i+1,j+1))
               image_pos2_fil(i,j) = image_pos2(i, j);
           else
               image_pos2_fil(i,j) = 0;
           end
        end
        
        % pos4
        [xx,yy] = find(image_pos4 > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image_pos4,i,j) && ~getPixel(image_pos4,i,j-1) && ~getPixel(image_pos4,i,j+1) && ~getPixel(image_pos4,i+1,j) && ~getPixel(image_pos4,i-1,j) && ~getPixel(image_pos4,i-1,j-1) && ~getPixel(image_pos4,i-1,j+1) && ~getPixel(image_pos4,i+1,j-1) && ~getPixel(image_pos4,i+1,j+1))
               image_pos4_fil(i,j) = image_pos4(i, j);
           else
               image_pos4_fil(i,j) = 0;
           end
        end
        
        % pos5
        [xx,yy] = find(image_pos5 > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image_pos5,i,j) && ~getPixel(image_pos5,i,j-1) && ~getPixel(image_pos5,i,j+1) && ~getPixel(image_pos5,i+1,j) && ~getPixel(image_pos5,i-1,j) && ~getPixel(image_pos5,i-1,j-1) && ~getPixel(image_pos5,i-1,j+1) && ~getPixel(image_pos5,i+1,j-1) && ~getPixel(image_pos5,i+1,j+1))
               image_pos5_fil(i,j) = image_pos5(i, j);
           else
               image_pos5_fil(i,j) = 0;
           end
        end
        
        % pos6
        [xx,yy] = find(image_pos6 > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image_pos6,i,j) && ~getPixel(image_pos6,i,j-1) && ~getPixel(image_pos6,i,j+1) && ~getPixel(image_pos6,i+1,j) && ~getPixel(image_pos6,i-1,j) && ~getPixel(image_pos6,i-1,j-1) && ~getPixel(image_pos6,i-1,j+1) && ~getPixel(image_pos6,i+1,j-1) && ~getPixel(image_pos6,i+1,j+1))
               image_pos6_fil(i,j) = image_pos6(i, j);
           else
               image_pos6_fil(i,j) = 0;
           end
        end
        
        % pos8
        [xx,yy] = find(image_pos8 > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image_pos8,i,j) && ~getPixel(image_pos8,i,j-1) && ~getPixel(image_pos8,i,j+1) && ~getPixel(image_pos8,i+1,j) && ~getPixel(image_pos8,i-1,j) && ~getPixel(image_pos8,i-1,j-1) && ~getPixel(image_pos8,i-1,j+1) && ~getPixel(image_pos8,i+1,j-1) && ~getPixel(image_pos8,i+1,j+1))
               image_pos8_fil(i,j) = image_pos8(i, j);
           else
               image_pos8_fil(i,j) = 0;
           end
        end
    else
        image_pos1_fil = image_pos1;
        image_pos2_fil = image_pos2;
        image_pos4_fil = image_pos4;
        image_pos5_fil = image_pos5;
        image_pos6_fil = image_pos6;
        image_pos8_fil = image_pos8;
    end
    
    %% Sum ...
    %pos1
    images_pos1 = images_pos1 + image_pos1;
    images_pos1_fil = images_pos1_fil + image_pos1_fil;
    
    %pos2
    images_pos2 = images_pos2 + image_pos2;
    images_pos2_fil = images_pos2_fil + image_pos2_fil;
    
        %pos4
    images_pos4 = images_pos4 + image_pos4;
    images_pos4_fil = images_pos4_fil + image_pos4_fil;
    
        %pos5
    images_pos5 = images_pos5 + image_pos5;
    images_pos5_fil = images_pos5_fil + image_pos5_fil;
    
        %pos6
    images_pos6 = images_pos6 + image_pos6;
    images_pos6_fil = images_pos6_fil + image_pos6_fil;
    
        %pos8
    images_pos8 = images_pos8 + image_pos8;
    images_pos8_fil = images_pos8_fil + image_pos8_fil;
    
    
    waitbar(k/value,h,sprintf('%i / %i',k,value));

end
close(h);

%% Merging ...

    %corners
    merge_fig(513-2*overlay_px:768-2*overlay_px, 513-2*overlay_px:768-2*overlay_px) = images_pos1; 
    merge_fig(1:256, 1:256) = flipud(fliplr(images_pos1));
    merge_fig(513-2*overlay_px:768-2*overlay_px, 1:256) = fliplr(images_pos1);
    merge_fig(1:256, 513-2*overlay_px:768-2*overlay_px) = flipud(images_pos1);
    %sides
    merge_fig(1:256, 257-overlay_px:512-overlay_px) = images_pos8;
    merge_fig(257-overlay_px:512-overlay_px, 1:256) = images_pos4;
    merge_fig(257-overlay_px:512-overlay_px, 513-2*overlay_px:768-2*overlay_px) = images_pos6;
    merge_fig(513-2*overlay_px:768-2*overlay_px, 257-overlay_px:512-overlay_px) = images_pos2;
    %center
    merge_fig(257-overlay_px:512-overlay_px, 257-overlay_px:512-overlay_px) = images_pos5;

% filtred
    %corners
        merge_fig_fil(513-2*overlay_px:768-2*overlay_px, 513-2*overlay_px:768-2*overlay_px) = images_pos1_fil;
        merge_fig_fil(1:256, 1:256) = flipud(fliplr(images_pos1_fil));
        merge_fig_fil(513-2*overlay_px:768-2*overlay_px, 1:256) = fliplr(images_pos1_fil);
        merge_fig_fil(1:256, 513-2*overlay_px:768-2*overlay_px) = flipud(images_pos1_fil);
    %sides
        merge_fig_fil(1:256, 257-overlay_px:512-overlay_px) = images_pos8_fil;
        merge_fig_fil(257-overlay_px:512-overlay_px, 1:256) = images_pos4_fil;
        merge_fig_fil(257-overlay_px:512-overlay_px, 513-2*overlay_px:768-2*overlay_px) = images_pos6_fil;
        merge_fig_fil(513-2*overlay_px:768-2*overlay_px, 257-overlay_px:512-overlay_px) = images_pos2_fil;
    %center
        merge_fig_fil(257-overlay_px:512-overlay_px, 257-overlay_px:512-overlay_px) = images_pos5_fil;
    

    
%% Plot
close all

x = linspace(px/1000/2,px/1000*length(merge_fig)-px/1000/2,length(merge_fig));
y = linspace(px/1000/2,px/1000*length(merge_fig)-px/1000/2,length(merge_fig));

figure('Name','Original merged image','NumberTitle','off');
imagesc(x,y,log(merge_fig));
axis square;
colormap(hot)
xlabel('x (mm)'); 
ylabel('y (mm)'); 

% Filtred
if(filter)
    figure('Name','Filtrred merged image','NumberTitle','off');
    imagesc(x,y,(merge_fig_fil));
    axis square;
   % colormap(hot)
    xlabel('x (mm)'); 
    ylabel('y (mm)');
    xlim
    set(gca,'XTick',[0 xticks])
end





