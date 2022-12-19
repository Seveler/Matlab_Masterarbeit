function [img_return] = combine_result_and_label(result_img, labeled_img)

img_height = size(labeled_img,1);
img_width = size(labeled_img,2);
R = 54;
G = 243;
B = 29;
for y=1:img_height
    for x=1:img_width
        if result_img(y,x) > 0
            labeled_img(y,x,1) = R;
            labeled_img(y,x,2) = G;
            labeled_img(y,x,3) = B;
        end
    end
end
img_return = labeled_img;