clear;
close all;

ending = ".tiff";

[filename,path] = uigetfile('*' + ending, 'Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\3.tiff');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,filename)]);
end
img_orig = imread(fullfile(path,filename));
imshow(img_orig)

img_var = (stdfilt(img_orig, true(11))).^2; % calculates variance
%img_var = single( img_var./max(max(img_var)) ); % normalization 
img_var = uint8(img_var);
figure, imshow(img_var);
var_thresh = 120;
img = img_var > var_thresh; % applies variance threshold
figure, imshow(img);

img = imfill(img,"holes");
figure, imshow(img);
img = bwareaopen(img, 800);
figure, imshow(img);