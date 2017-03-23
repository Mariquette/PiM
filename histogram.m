clear all; 
close all; 
clc;

folder_cal = uigetdir('Calib/', 'Select Directory with Calibration Data');
folder = uigetdir('Data/', 'Select Data Directory');

px = 55;        %velikost pixelu [um]
px_num = 256;   %pocet pixelu    
filter = true;  %filtrovat?
ToT_max = 2^16; %maximalni hodnota pixelu v ToT rezimu

%%  Loading ...
image_list = dir([folder, '/*.txt']);
%image_list = dir([folder, '/*image*']);
value = length(image_list); 
%value = 500;

% load calibration matrices    
a = load([folder_cal, '/_Calib_a.txt']);
b = load([folder_cal, '/_Calib_b.txt']);
c = load([folder_cal, '/_Calib_c.txt']);
t = load([folder_cal, '/_Calib_t.txt']);

%%
images = zeros(px_num);
images_fil = zeros(px_num);
counts = 0;
energies = 0;

h = waitbar(0,'Please wait...');
for k=1:value
    
    name = [folder,'/',image_list(k).name];
    image = load(name); 
%    disp(['loading image: ',image_list(k).name])

%% Maskovani    
%    image(:,1)=0;      %radek,sloupec    
%    image(256,:)=0;
%    image(:,1:2)=0;
%    image(255,4)=0;
    %% filtrace
    if filter 
        image_fil = zeros(px_num); 
        [xx,yy] = find(image > 0);
        for g=1:length(xx)
           i = xx(g);
           j = yy(g);
           if (getPixel(image,i,j) && ~getPixel(image,i,j-1) && ~getPixel(image,i,j+1) && ~getPixel(image,i+1,j) && ~getPixel(image,i-1,j) && ~getPixel(image,i-1,j-1) && ~getPixel(image,i-1,j+1) && ~getPixel(image,i+1,j-1) && ~getPixel(image,i+1,j+1))
               image_fil(i,j) = image(i, j);
           else
               image_fil(i,j) = 0;
           end
        end
    else
        image_fil = image;
    end
    
    %% vytvareni souctovych snimku   
    images = images + image;
    images_fil = images_fil + image_fil;
    
    %% kalibrace
    image_cal = (image_fil > 0) .* (( t.*a + image_fil - b + sqrt( (b + t.*a - image_fil).^2 + 4*a.*c ) ) ./ (2*a));
    n = find(image_cal > 0);
    energies(counts+1:counts+length(n)) = image_cal(n);
    counts = counts+length(n);
    
    %%
    waitbar(k/value,h,sprintf('%i / %i',k,value));
end
close(h);

%% vykresleni grafu 

x = linspace(px/1000/2,px/1000*px_num-px/1000/2,px_num);
y = linspace(px/1000/2,px/1000*px_num-px/1000/2,px_num);

figure();
imagesc(x,y,(images));
axis square;
title('Original image');
xlabel('x (mm)'); 
ylabel('y (mm)'); 
colormap(parula)
a = colorbar;
a.Label.String = 'Intensity (counts)';

figure();
imagesc(x,y,log(images_fil));
axis square; 
title('Filtred image');
xlabel('x (mm)'); 
ylabel('y (mm)');
colormap(parula)
b = colorbar;
b.Label.String = 'Intensity (counts)';

figure();
hist(energies,max(energies));
xlabel('E [kev]');
ylabel('Counts [-]');
xlim([0 100]);

figure();
[y,x] = hist(energies,max(energies));
plot(x,y);
set(gca, 'YScale', 'log');
xlabel('E [kev]');
ylabel('Counts [-]');
xlim([0 100]);
