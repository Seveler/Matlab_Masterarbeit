function [new_img] = noisy_flocs(img_orig)

% clear;
% close all;
% [dbfile,path] = uigetfile('*.tiff','Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\19.tiff');
% if isequal(dbfile,0)
%    disp('User selected Cancel');
% else
%    disp(['User selected ', fullfile(path,dbfile)]);
% end
% img_orig = imread(fullfile(path,dbfile));
% figure, imshow(img_orig);

img_height = size(img_orig,1);
img_width = size(img_orig,2);

h = fspecial('average',32);
img = double(img_orig);
img = 128 + img - imfilter(img,h);
img = uint8(img);
img = imadjust(img);
%figure, imshow(img);
median_colour = median(img(:)) + 10;
for y=1:img_height
    for x=1:img_width
        if img(y,x) < median_colour
            img(y,x) = 2*median_colour - img(y,x);
        end
    end
end
%figure, imshow(img);

img = medfilt2(img, [3 3]);
%figure, imshow(img);

se = strel('disk',10);
img = imclose(img,se);
median_after_closing = median(img(:));
%figure, imshow(img);

%figure, imhist(img);
[counts] = imhist(img);
peaks = zeros(size(counts,1),1);
range_val = 5;
peak = 255+2;
for i=1+range_val:size(counts,1)-range_val
    sum = 0;
    % sum of histogram counts within range around i
    for range=-range_val:range_val
        sum = sum + counts(i+range);
    end
    sum = sum - counts(i); % dont count counts at i
    if counts(i)>10^4 && (counts(i) > sum) && i > median_after_closing + 10  %(counts(i-5)+counts(i-4)+counts(i-3)+counts(i-2)+counts(i-1)+counts(i+1)+counts(i+2)+counts(i+3)+counts(i+4)+counts(i+5))
        peaks(i) = counts(i);
        peak = i;
    end
end
img = img > peak-2;
new_img = img;
%figure, imshow(new_img);
