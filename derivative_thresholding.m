clear;
close all;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_09_56_54.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
I = imresize(I,0.5);
figure;
imshow(I);

% kernel = [0,0,0;
%           10,0,-9;
%           0,0,0];
% I = imfilter(I,kernel);
% figure;
% imshow(I);

masksize = 5;
maskarea = masksize * masksize;
dist_to_mid = (masksize - mod(masksize,2)) / 2;
img_dim = size(I);
img_height = img_dim(1);
img_width = img_dim(2);
new_img = zeros(img_height, img_width,'logical');

for y=1:img_height-masksize
    for x=1:img_width-masksize
        counter = 0;
        pixel_positions = ones(masksize,'logical');
        intensity_sum = int16(0);
        
        image_mask = I(y:y+masksize-1,x:x+masksize-1);
        mean_intensity = mean(image_mask(:)); 
        
        if(I(y+dist_to_mid, x+dist_to_mid) > 1.4*mean_intensity)
            new_img(y+dist_to_mid, x+dist_to_mid) = 1;
        end
    end
end

figure;
imshow(new_img);