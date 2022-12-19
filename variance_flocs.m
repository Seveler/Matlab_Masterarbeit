function [img_return] = variance_flocs(img_orig)

img_var = (stdfilt(img_orig, true(47))).^2; % calculates variance 
img_var = linear_normalisation(img_var);
img_var = uint8(img_var);

var_thresh = 25;
img = img_var > var_thresh; % applies variance threshold
img = imfill(img,"holes");
img = bwareaopen(img, 1000);

img_return = img;