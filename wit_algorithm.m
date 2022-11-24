%% Wit algorithm

clear;
close all;
ending = ".tiff";
[filename,path] = uigetfile('*.tiff','Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\1.tiff');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,filename)]);
end
png = erase(filename,ending) + ".png";
labeled_img = imread(append('C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Masterarbeit\Messungen\Labeled_Data\Daten\Labeled\', filename));
% length = size(filename,2);
% filename(length-2:length) = 'bmp';
% before_dexined = imread(strcat('C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Hiwi\AI-Service\AI-Service\results\DexiNed\nocontrastadjustment_2022_10_27 14-42-45\inputs\',filename));
% figure, imshow(before_dexined);
% 
% filename(length-2:length) = 'png';
img_orig = imread(fullfile(path,filename));

img_height = size(img_orig,1);
img_width = size(img_orig,2);
figure, imshow(img_orig);

h = [1,2,1;
     2,4,2;
     1,2,1];
h = h/16;
img = imfilter(img_orig,h);
%figure, imshow(img);

h = fspecial('average',16);
img = double(img);
img = 128 + img - imfilter(img,h);
img = uint8(img);
figure, imshow(img);



img = img < 100;
figure, imshow(img);

img = bwareafilt(img, [300, img_height*img_width], 8); % Keep objects with pixelsize between [ , ]
figure, imshow(img);

figure, imshow(labeled_img);