function [new_img] = black_image_border(img_orig, thickness)

img_height = size(img_orig,1);
img_width = size(img_orig,2);

for y=1:img_height
    for x=1:thickness
        img_orig(y,x) = 0;
    end
    for x=img_width-thickness:img_width
        img_orig(y,x) = 0;
    end
end
for x=1:img_width
    for y=1:thickness
        img_orig(y,x) = 0;
    end
    for y=img_height-thickness:img_height
        img_orig(y,x) = 0;
    end
end

new_img = img_orig;