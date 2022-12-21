function [img_return] = combine_result_and_label(result_img, labeled_img, se_val)

se = strel('disk',se_val);
result_img = imdilate(result_img,se);

img_height = size(labeled_img,1);
img_width = size(labeled_img,2);
%Grün
gruen_R = 54;
gruen_G = 243;
gruen_B = 29;
%Orange
orange_R = 255;
orange_G = 204;
orange_B = 0;
%Rot
rot_R = 236;
rot_G = 28;
rot_B = 36;

sizes = size(labeled_img);
if size(sizes,2) ~= 3
    % add third dimension when image is grayscale
    labeled_img(:,:,2) = labeled_img(:,:,1);
    labeled_img(:,:,3) = labeled_img(:,:,1);
end

for y=1:img_height
    for x=1:img_width
        if result_img(y,x) > 0 && ~(labeled_img(y,x,1) == rot_R && labeled_img(y,x,2) == rot_G && labeled_img(y,x,3) == rot_B)
            labeled_img(y,x,1) = gruen_R;
            labeled_img(y,x,2) = gruen_G;
            labeled_img(y,x,3) = gruen_B;
        elseif result_img(y,x) > 0 && (labeled_img(y,x,1) == rot_R && labeled_img(y,x,2) == rot_G && labeled_img(y,x,3) == rot_B)
            labeled_img(y,x,1) = orange_R;
            labeled_img(y,x,2) = orange_G;
            labeled_img(y,x,3) = orange_B;
        elseif result_img(y,x) == 0 && (labeled_img(y,x,1) == rot_R && labeled_img(y,x,2) == rot_G && labeled_img(y,x,3) == rot_B)
            labeled_img(y,x,1) = rot_R;
            labeled_img(y,x,2) = rot_G;
            labeled_img(y,x,3) = rot_B;
        else

        end
    end
end
img_return = labeled_img;