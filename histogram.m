clear all; close all; clc;

folder_cal = uigetdir('Calib/', 'Select Directory with Calibration Data');
folder = uigetdir('Data/', 'Select Data Directory');

px = 55; %velikost pixelu [um]
px_num = 256; %pocet pixelu    
filter = false; %filtrovat?
ToT_max = 2^16; %maximalni hodnota pixelu v ToT rezimu

%% 
%image_list = dir([folder, '/*.txt']);
image_list = dir([folder, '/*image*']);
value = length(image_list); 

% load calibration matrices    
a = load([folder_cal, '/_Calib_a.txt']);
b = load([folder_cal, '/_Calib_b.txt']);
c = load([folder_cal, '/_Calib_c.txt']);
t = load([folder_cal, '/_Calib_t.txt']);

%%
images = zeros(px_num);
images_fil = zeros(px_num);
counts = 0;
energies = zeros(ToT_max,1);

h = waitbar(0,'Please wait...');
for k=1:value
    
    name = [folder,'/',image_list(k).name];
    image = load(name); 
    disp(['loading image: ',image_list(k).name])
    
    %% filtrace
    if filter 
        image_fil = zeros(px_num); 
        [xx,yy] = find(image > 0);
        for g=1:length(i)
           i = xx(g);
           j = yy(g);
           if (getPixel(image,i,j) && ~getPixel(image,i,j-1) && ~getPixel(image,i,j+1) && ~getPixel(image,i-1,j-1) && ~getPixel(image,i-1,j) && ~getPixel(image,i-1,j+1) && ~getPixel(image,i+1,j-1) && ~getPixel(image,i+1,j) && ~getPixel(image,i+1,j+1))
               image_fil(i,j) = image(i, j);
           else
               image_fil(i,j) = 0;
           end
        end
    else
        image_fil = image;
    end
    
    %% kalibrace   
    images = images + image;
    images_fil = images_fil + image_fil;
    
    image_cal = (image_fil > 0) .* (( t.*a + image_fil - b + sqrt( (b + t.*a - image_fil).^2 + 4*a.*c ) ) ./ (2*a));
    n = find(image_cal > 0);
    energies(counts+1:counts+length(n)) = image_cal(n);
    counts = counts+length(n);
    
    %%
    waitbar(k/value,h,sprintf('%i / %i',k,value));
end
close(h);

%% vykresleni grafu 
figure(1);
x = linspace(px/1000/2,px/1000*px_num-px/1000/2,px_num);
y = linspace(px/1000/2,px/1000*px_num-px/1000/2,px_num);
imagesc(x,y,images);
axis square; 
xlabel('x (mm)'); 
ylabel('y (mm)'); 
colorbar;

figure(2);
imagesc(x,y,images_fil);
axis square; 
xlabel('x (mm)'); 
ylabel('y (mm)'); 
colorbar;

figure(3);
hist(energies,length(energies));
xlabel('E [kev]');
ylabel('Counts [-]');
xlim([0 100]);
