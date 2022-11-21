close all;
clear;

nhood_little = [0,0,1,0,0;
         0,1,1,1,0;
         1,1,1,1,1;
         0,1,1,1,0; 
         0,0,1,0,0];

nhood = [0,0,0,1,1,1,1,0,0,0;
         0,0,1,1,1,1,1,1,0,0;
         0,1,1,1,1,1,1,1,1,0;
         1,1,1,1,1,1,1,1,1,1;
         1,1,1,1,1,1,1,1,1,1;
         1,1,1,1,1,1,1,1,1,1;
         1,1,1,1,1,1,1,1,1,1;
         0,1,1,1,1,1,1,1,1,0;
         0,0,1,1,1,1,1,1,0,0;
         0,0,0,1,1,1,1,0,0,0];


[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_09_56_54.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

Img = imread(fullfile(path,dbfile));
Img = imresize(Img,0.5);  % Img is later used for floc detection

I_size = size(Img);
img_height = I_size(1);
img_width = I_size(2);

I = imadjust(Img);
figure, imshow(I);

kernel_vertical = [0,0,0;
                    10,0,-10;
                     0,0,0];
kernel_horizontal = [0,10,0;
                   0,0,0;
                   0,-10,0];

I1 = imfilter(I,kernel_horizontal);
I2 = imfilter(I,kernel_vertical);

I1 = double(I1);
I2 = double(I2);

I3 = sqrt(I1.^2 + I2.^2);
I = uint8(I3);
%I = max(I1,I2);
figure, imshow(I);

I = imregionalmax(I);
figure, imshow(I);


I = bwareafilt(I, [4, 2000], 4); % Keep objects with pixelsize between [ , ]
figure, imshow(I);
%I = bwareafilt(I, [5, 2000], 8); % Keep objects with pixelsize between [ , ]
%figure, imshow(I);

%% delete non-circular connected objects
connected_objects = bwconncomp(I,4);
stats = regionprops(connected_objects,"Eccentricity");

for i=1:connected_objects.NumObjects
    if(stats(i).Eccentricity < 0.95)
        % delete object
        len = size(connected_objects.PixelIdxList{1,i});
        len = len(1);
        for pixelnum=1:len
            pixel = connected_objects.PixelIdxList{1,i}(pixelnum);
            I(pixel) = 0;
        end
    end
end

figure, imshow(I);



%% find flocs and remove

% mean_filter = [1/25,1/25,1/25,1/25,1/25;
%          1/25,1/25,1/25,1/25,1/25;
%          1/25,1/25,1/25,1/25,1/25;
%          1/25,1/25,1/25,1/25,1/25; 
%          1/25,1/25,1/25,1/25,1/25];
% 
% Img = imadjust(Img);
% Img = imfilter(Img,mean_filter);
% Img = imadjust(Img);
% img_var = single( (stdfilt(Img)).^2 ); % calculates variance
% img_var = single( img_var./max(max(img_var)) ); % normalization 
% var_thresh = 0.0025;
% Img = img_var > var_thresh; % applies variance threshold
% %figure, imshow(Img);
% 
% % set 3px-borders to black (otherwise imfill("holes") makes whole image
% % white)
% for x=1:img_width
%     Img(1,x) = 0;
%     Img(2,x) = 0;
%     Img(3,x) = 0;
%     Img(4,x) = 0;
%     Img(img_height-3,x) = 0;
%     Img(img_height-2,x) = 0;
%     Img(img_height-1,x) = 0;
%     Img(img_height,x) = 0;
% end
% for y=1:img_height
%     Img(y,1) = 0;
%     Img(y,2) = 0;
%     Img(y,3) = 0;
%     Img(y,4) = 0;
%     Img(y,img_width-3) = 0;
%     Img(y,img_width-2) = 0;
%     Img(y,img_width-1) = 0;
%     Img(y,img_width) = 0;
% end
% 
% figure, imshow(Img);
% Img = imfill(Img,4,"holes");
% figure, imshow(Img);
% Img = medfilt2(Img,[3 3]);
% figure, imshow(Img);
% Img = bwareafilt(Img, [50, img_height*img_width], 4); % Keep objects with pixelsize between [ , ]
% figure, imshow(Img);
% % SE = strel('square',5);
% % Img = imdilate(Img,SE);
% % figure, imshow(Img);
% % Img = bwareafilt(Img, [400, img_height*img_width], 8); % Keep objects with pixelsize between [ , ]
% % figure, imshow(Img);
% % Img = imfill(Img,8,"holes");
% 
% connected_objects = bwconncomp(Img,8);
% stats = regionprops(connected_objects,"Eccentricity");
% 
% for i=1:connected_objects.NumObjects
%     if(stats(i).Eccentricity > 0.95)
%         % delete object
%         len = size(connected_objects.PixelIdxList{1,i});
%         len = len(1);
%         for pixelnum=1:len
%             pixel = connected_objects.PixelIdxList{1,i}(pixelnum);
%             Img(pixel) = 0;
%         end
%     end
% end
% 
% figure, imshow(Img);
% 
% for y=1:img_height
%     for x=1:img_width
%         if(I(y,x) == 1 && Img(y,x) == 1)
%             I(y,x) = 0;
%         end
%     end
% end
% figure, imshow(I);