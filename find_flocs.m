clear;
%close all;

imagefiles = dir('..\Messungen\2109\*.bmp');
start_file = 1;
nfiles = 2; %length(imagefiles);

highpass = [-1,-1,-1;
          -1,8,-1;
          -1,-1,-1];
highpass2 = [1/25,1/25,1/25,1/25,1/25;
         1/25,1/25,1/25,1/25,1/25;
         1/25,1/25,1/25,1/25,1/25;
         1/25,1/25,1/25,1/25,1/25; 
         1/25,1/25,1/25,1/25,1/25];
lowpass = [0,1,0;
          1,2,1;
          0,1,0];

% for i=1:nfiles
%     I = imread(append('..\Messungen\2109\', imagefiles(i+start_file).name));
%     subplot(nfiles,2,2*i-1);
%     I = imadjust(I);
%     imshow(I);
% 
%     subplot(nfiles,2,2*i);
%     
% 
%     I = imfilter(I,highpass2);
%     I = imadjust(I);
%     imshow(I);
% end
% img_var = single( (stdfilt(I)).^2 ); % calculates variance
% img_var = single( img_var./max(max(img_var)) ); % normalization 
%  
% var_thresh = 0.0025;                                          % during variance calculation
% img_bw = img_var > var_thresh; % applies variance threshold
% figure, imshow(img_bw);



[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\Mai\1705_klaeranlage_tubus_2.7\2022_05_17_15_36_27_96.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
figure, imshow(I);
I_size = size(I);
img_height = I_size(1);
img_width = I_size(2);
I = imadjust(I);
I = imfilter(I,highpass2);
I = imadjust(I);
img_var = single( (stdfilt(I)).^2 ); % calculates variance
img_var = single( img_var./max(max(img_var)) ); % normalization 
var_thresh = 0.0025;
I = img_var > var_thresh; % applies variance threshold
figure, imshow(I);

% set 3px-borders to black (otherwise imfill("holes") makes whole image
% white)
for x=1:img_width
    I(1,x) = 0;
    I(2,x) = 0;
    I(3,x) = 0;
    I(4,x) = 0;
    I(img_height-3,x) = 0;
    I(img_height-2,x) = 0;
    I(img_height-1,x) = 0;
    I(img_height,x) = 0;
end
for y=1:img_height
    I(y,1) = 0;
    I(y,2) = 0;
    I(y,3) = 0;
    I(y,4) = 0;
    I(y,img_width-3) = 0;
    I(y,img_width-2) = 0;
    I(y,img_width-1) = 0;
    I(y,img_width) = 0;
end

% I = padarray(I,[1 1],0,'both');
figure, imshow(I);
I = imfill(I,4,"holes");
figure, imshow(I);
I = medfilt2(I,[3 3]);
figure, imshow(I);
I = bwareafilt(I, [50, img_height*img_width], 4); % Keep objects with pixelsize between [ , ]
figure, imshow(I);
SE = strel('square',5);
I = imdilate(I,SE);
figure, imshow(I);
I = bwareafilt(I, [400, img_height*img_width], 8); % Keep objects with pixelsize between [ , ]
figure, imshow(I);
I = imfill(I,8,"holes");

connected_objects = bwconncomp(I,8);
stats = regionprops(connected_objects,"Eccentricity");

for i=1:connected_objects.NumObjects
    if(stats(i).Eccentricity > 0.95)
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

% for var_thresh=0.002:0.001:0.005
%     img_var = single( (stdfilt(I)).^2 ); % calculates variance
%     img_var = single( img_var./max(max(img_var)) ); % normalization 
%     I1 = img_var > var_thresh; % applies variance threshold
%     figure, imshow(I1);
% end