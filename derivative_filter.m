close all;
clear;

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

I = imread(fullfile(path,dbfile));
I = imresize(I,0.5);
%figure, imshow(I);
I = imadjust(I);
figure, imshow(I);

img_height = size(I,1);
img_width = size(I,2);

% h = [1,2,1;
%      2,4,2;
%      1,2,1];
% h = h/16;
% I = imfilter(I,h);
I = imgaussfilt(I,0.5);
figure, imshow(I);
% BW1 = edge(I,'Canny');
% figure;
% imshow(BW1);
% BW2 = edge(I,'Sobel');
% figure;
% imshow(BW2);
% BW2 = edge(I,'Prewitt');
% BW3 = edge(I,'Sobel');
% BW4 = edge(I,'roberts');
% BW5 = edge(I,'log');
% BW6 = edge(I,'approxcanny');
%factor = 0.5;
%I = imresize(I,factor);


kernel_horizontal = [0,0,0;
                    10,0,-10;
                     0,0,0];
kernel_vertical = [0,10,0;
                   0,0,0;
                   0,-10,0];

%I1 = imfilter(I,kernel_horizontal);
I1 = conv2(I,kernel_horizontal);
%I1 = imadjust(I1);
%I2 = imfilter(I,kernel_vertical);
I2 = conv2(I,kernel_vertical);
%I2 = imadjust(I2);

figure, imshow(I1);
figure, imshow(I2);

I1 = double(I1);
I2 = double(I2);

I3 = sqrt(I1.^2 + I2.^2);
%I3 = max(I1,I2);
%I3 = uint8(I3);
%I3 = imadjust(I3);
img = uint8(I3);
figure, imshow(img);

h = fspecial('average',32);
img = double(img);
img = 128 + img - imfilter(img,h);
I = uint8(img);
%figure, imshow(I);

% I = imregionalmax(I);
% figure, imshow(I);

I = medfilt2(I,[5 5]);
%figure, imshow(I);

t_map = I;
%for t_diff=90:30:210
t_diff = 30;
%figure, imshow(t_map);

new_img = zeros(img_height, img_width,'logical');
diff_r = int8(0);
diff_l = int8(0);
diff_o = int8(0);
diff_u = int8(0);
diff_ro = int8(0);
diff_ru = int8(0);
diff_lo = int8(0);
diff_lu = int8(0);
%% compare with threshold map
% d_min = 5;
% step =  5;
% d_max = 20;
% % d = 10;
% % d_max = 10;
% 
% for y=1+d_max:img_height-d_max
%     for x=1+d_max:img_width-d_max
%         counter = 0;
%         for d=d_min:step:d_max
%             diff_r = I(y,x) - t_map(y,x+d);
%             diff_l = I(y,x) - t_map(y,x-d);
%             diff_o = I(y,x) - t_map(y+d,x);
%             diff_u = I(y,x) - t_map(y-d,x);
%     
%             diff_ro = I(y,x) - t_map(y+d,x+d);
%             diff_ru = I(y,x) - t_map(y-d,x+d);
%             diff_lo = I(y,x) - t_map(y+d,x-d);
%             diff_lu = I(y,x) - t_map(y-d,x-d);
%             
%             num_t_diffs = 0;
%             if(diff_r > t_diff || diff_r < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             if(diff_l > t_diff || diff_l < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             if(diff_o > t_diff || diff_o < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             if(diff_u > t_diff || diff_u < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%     
%             if(diff_ro > t_diff || diff_ro < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             if(diff_ru > t_diff || diff_ru < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             if(diff_lo > t_diff || diff_lo < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             if(diff_lu > t_diff || diff_lu < -t_diff)
%                 num_t_diffs = num_t_diffs + 1;
%             end
%             
%             %funktioniert nur mit 4 gut
%             if(num_t_diffs > 6)
%                 counter = counter + 1;
%                 %new_img(y,x) = 1;
%             end
%         end
%         if(counter == 3)
%             new_img(y,x) = 1;
%         end
%     end
% end
% 
% figure, imshow(new_img);
% 
% I = imbinarize(I,50);
% figure, imshow(I);

