clear;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_10_02_55.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I2 = imread(fullfile(path,dbfile));

corners   = detectFASTFeatures(im2gray(I2));
strongest = selectStrongest(corners,3);

[hog2,validPoints,ptVis] = extractHOGFeatures(I2,strongest);

figure;
imshow(I2);
hold on;
plot(ptVis,'Color','green');