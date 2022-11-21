close all;
[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_09_56_54.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
%I = imresize(I,0.5);
%figure, imshow(I);

% Noise removal

% K = filter2(fspecial('average',3),I)/255;
% figure, imshow(K);
% K = medfilt2(I,[3 3]);
% figure, imshow(K);

se = strel('disk',12);
I = imtophat(I,se);
I = imadjust(I);    % necessary because pixel range is much lower [0-~10]
figure, imshow(I);


% I = medfilt2(I,[5 5]);
% figure, imshow(I);

I_max = imregionalmax(I);
figure, imshow(I_max);
%I_min = imregionalmin(I);  % connect with or gate
%figure, imshow(I_min);

I_max = medfilt2(I_max,[3 3]);
figure, imshow(I_max);
I_max = imfill(I_max,8,'holes');

se = strel('disk',2);
I_max = imdilate(I_max,se);
I_max = imdilate(I_max,se);
I_max = imdilate(I_max,se);
figure, imshow(I_max);
% I_min = medfilt2(I_min,[3 3]);
% figure, imshow(I_min);

% I = imextendedmax(I,100);
% figure, imshow(I);

% I = imhmax(I,2);
% figure, imshow(I);

I_max = bwareafilt(I_max, [1000, 8000], 8); % Keep objects with pixelsize between [ , ]
figure, imshow(I_max);

nhood = [0,0,1,0,0;
         0,1,1,1,0;
         1,1,1,1,1;
         0,1,1,1,0; 
         0,0,1,0,0];
%I = imclose(I_max,nhood);
%figure, imshow(I);