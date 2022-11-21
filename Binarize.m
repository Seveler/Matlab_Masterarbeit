
I = imread("..\Messungen\2109\2022_09_21_11_11_33_48.bmp");
BW = imbinarize(I,'adaptive','ForegroundPolarity','bright','Sensitivity',0.65);

figure
imshowpair(I,BW,'montage')