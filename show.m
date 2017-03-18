function [] = show(name)
% funkce na vykresleni obrazku
% pouziti: 
% show('nazev'); bez pripony !!!

    px = 55; %velikost pixelu [um]
    px_num = 256; %pocet pixelu

    image = load([name,'.txt']);
    meta = importdata([name,'.metadata.txt'],'\n');
    
    figure(1);
    x = linspace(px/1000/2,px/1000*px_num-px/1000/2,px_num);
    y = linspace(px/1000/2,px/1000*px_num-px/1000/2,px_num);
    imagesc(x,y,image);
    axis square; 
    xlabel('x (mm)'); 
    ylabel('y (mm)'); 
    colorbar;

    disp(meta);

end