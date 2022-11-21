close all;
clear;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_09_56_54.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
%se = strel('disk',12);
%I = imtophat(I,se);
%I = imadjust(I);    % necessary because pixel range is much lower [0-~10]
I = imresize(I,0.5);
I = imadjust(I);
figure, imshow(I);

kernel = [0,0,0;
          10,0,-9;
          0,0,0];
%I = imfilter(I,kernel);
%I = imadjust(I,[0.2 0.7]);
%figure, imshow(I);

meanIntensity = mean(I(:));
global_threshold = int8(meanIntensity)+5;

%for threshold=70:5:80
threshold = int8(meanIntensity)-20;
disp("meanIntensity: " + meanIntensity);
masksize = 3;
maskarea = masksize * masksize;
num_edge_pixels = 4*masksize - 4;
area_lower_threshold = (maskarea - mod(maskarea,2)) / 2;
area_upper_threshold = maskarea - masksize +1;
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
        for b=1:masksize
            for a=1:masksize
                if(I(y+b-1,x+a-1)<threshold)
                    counter = counter + 1;
                    pixel_positions(b,a) = 0;
                end
                intensity_sum = intensity_sum + int16(I(y+b-1,x+a-1));
            end
        end
        if(counter > area_lower_threshold && counter < area_upper_threshold)
            %if ~(pixel_positions(1,1)&&pixel_positions(3,3) || pixel_positions(1,2)&&pixel_positions(3,2) || pixel_positions(1,3)&&pixel_positions(3,1) || pixel_positions(2,3)&&pixel_positions(2,1))
                new_img(y+dist_to_mid,x+dist_to_mid) = 0;
            %end
        else
            new_img(y+dist_to_mid,x+dist_to_mid) = 1;
        end
        global_threshold = int8(intensity_sum/maskarea)+5;

        %mask = I(y:y+5,x:x+5);
        %mask = imcomplement(mask);
%         edgeisblack = false;
%         counter_black_edge_pixels = 0;
%         for top=1:masksize
%             if (pixel_positions(1,top) == 0)
%                 edgeisblack = true;
%                 counter_black_edge_pixels = counter_black_edge_pixels + 1;
%                 %return;
%             end
%         end
%         if(~edgeisblack)
%             for bottom=1:masksize
%                 if (pixel_positions(masksize,bottom) == 0)
%                     edgeisblack = true;
%                     counter_black_edge_pixels = counter_black_edge_pixels + 1;
%                     %return;
%                 end
%             end
%         end
%         if(~edgeisblack)
%             for left=2:masksize-1
%                 if (pixel_positions(left,1) == 0)
%                     edgeisblack = true;
%                     counter_black_edge_pixels = counter_black_edge_pixels + 1;
%                     %return;
%                 end
%             end
%         end
%         if(~edgeisblack)
%             for right=2:masksize-1
%                 if (pixel_positions(right,masksize) == 0)
%                     edgeisblack = true;
%                     counter_black_edge_pixels = counter_black_edge_pixels + 1;
%                     %return;
%                 end
%             end
%         end

        %pixel_positions = imcomplement(pixel_positions);
%         shape_info = bwconncomp(pixel_positions,4);
%         num_white_edge_pixels = num_edge_pixels - counter_black_edge_pixels;
%         if(num_white_edge_pixels > masksize +2 && num_white_edge_pixels < 3*masksize && edgeisblack && shape_info.NumObjects == 2 && counter > area_lower_threshold && counter < area_upper_threshold)
%             new_img(y+2,x+2) = 0;
%             %figure;
%             %imshow(pixel_positions);
%             %figure;
%             %imshow(I(y:y+masksize,x:x+masksize));
%             %disp("coordinates: (" + num2str(y) + "," + num2str(x) + ")");
%         else
%             new_img(y+2,x+2) = 1;
%         end
    end
end

figure;
imshow(new_img);

%end