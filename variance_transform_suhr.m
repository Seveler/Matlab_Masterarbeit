clear;
close all;

ending = ".tiff";

[filename,path] = uigetfile('*' + ending, 'Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\3.tiff');
%[filename,path] = uigetfile('*' + ending, 'Select an icon file','..\Wit_Algorithm\WIT 3.bmp');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,filename)]);
end
img_orig = imread(fullfile(path,filename));
imshow(img_orig)

img_height = size(img_orig,1);
img_width = size(img_orig,2);

img_var = (stdfilt(img_orig, true(19))).^2; % calculates variance
%img_var = single( img_var./max(max(img_var)) ); % normalization 

img_var = linear_normalisation(img_var);

%img_var = imadjust(img_var);
img_var = uint8(img_var);
figure, imshow(img_var);
var_thresh = 25;
img = img_var > var_thresh; % applies variance threshold
figure, imshow(img);

img = imfill(img,"holes");
figure, imshow(img);
img = bwareaopen(img, 1000);
figure, imshow(img);