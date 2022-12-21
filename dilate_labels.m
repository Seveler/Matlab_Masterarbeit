function [img_return] = dilate_labels(labeled_img, se_val)

img_height = size(labeled_img,1);
img_width = size(labeled_img,2);
%Rot
rot_R = 236;
rot_G = 28;
rot_B = 36;
binary_img = zeros(img_height,img_width);

sizes = size(labeled_img);
if size(sizes,2) == 3
    for y=1:img_height
        for x=1:img_width
            if labeled_img(y,x,1) == rot_R && labeled_img(y,x,2) == rot_G && labeled_img(y,x,3) == rot_B
                binary_img(y,x) = 255;
            end
        end
    end
end

se = strel('disk',se_val);
binary_img = imdilate(binary_img,se);
for y=1:img_height
    for x=1:img_width
        if binary_img(y,x) == 255
            labeled_img(y,x,1) = rot_R;
            labeled_img(y,x,2) = rot_G;
            labeled_img(y,x,3) = rot_B;
        end
    end
end
img_return = labeled_img;