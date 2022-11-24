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
I_size = size(img_orig);
img_height = size(img_orig,1);
img_width = size(img_orig,2);

h = fspecial('average',32);
img = double(img_orig);
img = 128 + img - imfilter(img,h);
img = uint8(img);
%figure, imshow(img);

%img = colour_image_border(img, 15, 128);
%figure, imshow(img);

img = imadjust(img);
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

% %% remove elongated objects (filaments)
% %% Reduced radius of gyration
% RG_thresh = 1.3;
% [L,N] = bwlabel(new_img,8); % isolates each object present in image
% 
% obj_centroids = regionprops(L, 'Centroid'); % centroids of each object
% obj_diameters = regionprops(L, 'EquivDiameter'); % equiv.diameter of " "
% obj_listPixels = regionprops(L,'PixelIdxList'); % list of white pixels 
%                                                 % composing each obj.
% RG = zeros(N,1); %vector containing values R.R.G. for each obj.
% map_rg = L;
% 
% for i = 1:N    
%     
%     % coordinates (x,y) of each pixel composing the object
%     [pixels_y,pixels_x] = ind2sub(size(new_img),obj_listPixels(i).PixelIdxList);   
%     
%     % computes distance between each pixel and the obj.'s centroid
%     sum_x = sum( (pixels_x - obj_centroids(i,1).Centroid(1,1)).^2 );
%     sum_y = sum( (pixels_y - obj_centroids(i,1).Centroid(1,2)).^2 );
% 
%     % computes the moments in each axis
%     M2x = sum_x/length(pixels_x);
%     M2y = sum_y/length(pixels_y);
%     
%     % computes the R.R.G.
%     RG(i) = sqrt(M2x + M2y) / (obj_diameters(i).EquivDiameter ./2); 
%     
%     % applies R.R.G. threshold
%     if RG(i) < RG_thresh
%         new_img(obj_listPixels(i).PixelIdxList) = 1;          
%     else
%         new_img(obj_listPixels(i).PixelIdxList) = 0;
%     end
% end
%figure ,imshow(new_img);

