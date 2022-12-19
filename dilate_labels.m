function [img_return] = dilate_labels(labeled_img)

img_height = size(labeled_img,1);
img_width = size(labeled_img,2);
R = 236;
G = 28;
B = 36;
binary_img = zeros(img_height,img_width);

for y=1:img_height
    for x=1:img_width
        if labeled_img(y,x,1) == R && labeled_img(y,x,2) == G && labeled_img(y,x,3) == B
            binary_img(y,x) = 255;
        end
    end
end
se = strel('disk',5);
binary_img = imdilate(binary_img,se);

for y=1:img_height
    for x=1:img_width
        if binary_img(y,x) == 255
            labeled_img(y,x,1) = R;
            labeled_img(y,x,2) = G;
            labeled_img(y,x,3) = B;
        end
    end
end
img_return = labeled_img;