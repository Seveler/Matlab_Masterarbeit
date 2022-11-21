function [new_img] = find_flocs2(img_orig)

% clear;
% close all;

% ending = ".tiff";

% [filename,path] = uigetfile('*' + ending, 'Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\1.tiff');
% if isequal(filename,0)
%    disp('User selected Cancel');
% else
%    disp(['User selected ', fullfile(path,filename)]);
% end
% png = erase(filename,ending) + ".png";
% dexi_img = imread(append('..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\outputs\', png));

se = strel('disk',5);

%img_orig = imread(append('..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\', filename));
%I = imresize(I, 0.5);
%figure, imshow(img_orig);
I_size = size(img_orig);
img_height = I_size(1);
img_width = I_size(2);
I = imadjust(img_orig);
%figure, imshow(I);
%figure, imhist(I);
med = median(I(:));
%figure, imshow(I);
IT1 = I > 50;

IGaus = imgaussfilt(I,5);
%figure, imshow(IGaus);
for y=1:img_height
    for x=1:img_width
        if I(y,x) < med - 60 %80
            I(y,x) = 0;
        end
    end
end

%figure, imshow(I);
%I = imclose(I,se);
%figure, imshow(I);

I = imgaussfilt(I,4);
Ier = imerode(I,se);
% figure, imshow(Ier);

th_erode = 70;
for y=1:img_height
    for x=1:img_width
        if Ier(y,x) < th_erode && I(y,x) < 60
            I(y,x) = 0;
        end
    end
end
%figure, imshow(I);

changes = true;
while changes
    changes = false;
    Ier = imerode(I,se);
    % multiple erosions in this step dont matter due to while loop
    %figure, imshow(Ier);
    
    for y=1:img_height
        for x=1:img_width
            if Ier(y,x) < th_erode && I(y,x) >= 5 && I(y,x) < IGaus(y,x) - 0 %120
                I(y,x) = 0;
                changes = true;
            end
        end
    end
end
%figure, imshow(I);
I = I == 0;
%figure, imshow(I);
%% add flocs from highpass filtering


img_flocs = noisy_flocs(img_orig);
%figure, imshow(img_flocs);

img_flocs = img_flocs | I;
%figure, imshow(img_flocs);

img = bwareaopen(img_flocs, 100);
%figure, imshow(img);
new_img = img;

% for i=1:5
%     I = imopen(I, se);
%     figure, imshow(I);
% end

% se = strel('disk',1);
% for i=1:3
%     Ier = imerode(I,se);
%     Ier = imerode(Ier,se);
%     I = imerode(Ier,se);
% end
% figure, imshow(I);

% new_img = dexi_img < 150 & I > 0;
% new_img = skeletonizeDexi(new_img);
%figure, imshow(new_img);

%figure, imshow(dexi_img);
%new_img = skeletonizeDexi(dexi_img);
%figure, imshow(new_img);


%% after erosion has finished add some additional erosions, since edges in dexined images often exceed the flocs area
%% RRG nachträglich???

% Ic = imclose(I,se);
% Io = imopen(I,se);
% %figure, imshow(Ic);
% %figure, imshow(Io);
% 
% 
% 
% Ib = imbothat(I,se);
% Ib = imadjust(Ib);
% %figure, imshow(Ib);
% 
% It = imtophat(I,se);
% It = imadjust(It);
% %figure, imshow(It);
