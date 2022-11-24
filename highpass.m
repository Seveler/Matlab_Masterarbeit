clear;
%close all;

[dbfile,path] = uigetfile('*.tiff','Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\19.tiff');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

img_orig = imread(fullfile(path,dbfile));
figure, imshow(img_orig);

img_height = size(img_orig,1);
img_width = size(img_orig,2);

h = [1,2,1;
     2,4,2;
     1,2,1];
h = h/16;
%img = imfilter(img_orig,h);
%figure, imshow(img);

h = fspecial('average',32);
img = double(img_orig);
img = 128 + img - imfilter(img,h);
img = uint8(img);
img = imadjust(img);
figure, imshow(img);

median_colour = median(img(:)) + 10;
%img = img + 2*(56-img) .* ((2*(56-img)) > median_colour);

for y=1:img_height
    for x=1:img_width
        if img(y,x) < median_colour
            img(y,x) = 2*median_colour - img(y,x);
        end
    end
end
figure, imshow(img);
% img = medfilt2(img,[5 5]);
% figure, imshow(img);
se = strel('disk',10);
img = imclose(img,se);
figure, imshow(img);
figure, imhist(img);

[counts] = imhist(img);
peaks = zeros(size(counts,1),1);
range_val = 10;
for i=1+range_val:size(counts,1)-range_val
    sum = 0;
    for range=-range_val:range_val
        sum = sum + counts(i+range);
    end
    sum = sum - counts(i);
    if counts(i) > sum %(counts(i-5)+counts(i-4)+counts(i-3)+counts(i-2)+counts(i-1)+counts(i+1)+counts(i+2)+counts(i+3)+counts(i+4)+counts(i+5))
        peaks(i) = counts(i);
        peak = i;
    end
end
figure, plot(1:size(peaks,1),peaks);

img = img > peak-2;
figure, imshow(img);
