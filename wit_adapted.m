%% Wit algorithm with adaptions

clear;
close all;
ending = ".jpg";
[filename,path] = uigetfile('*' + ending,'Select an icon file','..\..\Masterarbeit\Messungen\KlaeranlageLeverkusenTurm 15_25_27 9_45_15_2022_11_16 15-06-59\0.jpg');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,filename)]);
end
png = erase(filename,ending) + ".png";
%labeled_img = imread(append('C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Masterarbeit\Messungen\Labeled_Data\Daten\Labeled\', filename));
% length = size(filename,2);
% filename(length-2:length) = 'bmp';
% before_dexined = imread(strcat('C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Hiwi\AI-Service\AI-Service\results\DexiNed\nocontrastadjustment_2022_10_27 14-42-45\inputs\',filename));
% figure, imshow(before_dexined);
% 
% filename(length-2:length) = 'png';
img_orig = imread(fullfile(path,filename));
img_orig = rgb2gray(img_orig);
figure, imshow(img_orig);

img_height = size(img_orig,1);
img_width = size(img_orig,2);
figure, imshow(img_orig);
%img = imadjust(img_orig);
h = [1,2,1;
     2,4,2;
     1,2,1];
h = h/16;

%img = imgaussfilt(img_orig,2);


h = fspecial('average',32);
img = double(img_orig);
img = 128 + img - imfilter(img,h);
img = uint8(img);
figure, imshow(img);

img = imadjust(img);
median_colour = median(img(:)) + 10;
for y=1:img_height
    for x=1:img_width
        if img(y,x) < median_colour
            img(y,x) = 2*median_colour - img(y,x);
        end
    end
end
figure, imshow(img);

img = medfilt2(img, [3 3]);
%figure, imshow(img);

se = strel('disk',3);
img = imclose(img,se);
median_after_closing = median(img(:));
%figure, imshow(img);

%figure, imhist(img);
[counts] = imhist(img);
peaks = zeros(size(counts,1),1);
range_val = 5;
peak = 255+2;
for i=1+range_val:size(counts,1)-range_val
    sum_peaks = 0;
    % sum_peaks of histogram counts within range around i
    for range=-range_val:range_val
        sum_peaks = sum_peaks + counts(i+range);
    end
    sum_peaks = sum_peaks - counts(i); % dont count counts at i
    if counts(i)>10^4 && (counts(i) > sum_peaks) && i > median_after_closing + 10  %(counts(i-5)+counts(i-4)+counts(i-3)+counts(i-2)+counts(i-1)+counts(i+1)+counts(i+2)+counts(i+3)+counts(i+4)+counts(i+5))
        peaks(i) = counts(i);
        peak = i;
    end
end
img = img > peak-2;
new_img = img;
%figure, imshow(new_img);

% img = img < 100;
% figure, imshow(img);
% 
% img = bwareafilt(img, [300, img_height*img_width], 8); % Keep objects with pixelsize between [ , ]
% figure, imshow(img);

%figure, imshow(labeled_img);