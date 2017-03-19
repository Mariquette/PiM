function [x,y,image_roi] = roi(image)
    figure(100); 
    imagesc(image); 
    axis image; 
    colorbar; 

    [x_lim,y_lim] = ginput(2);
    
    y = round(y_lim(1)):round(y_lim(2));
    x = round(x_lim(1)):round(x_lim(2));
    image_roi = image(y,x);
end