function [new_img] = colour_image_border(img_orig, thickness, colour)

img_height = size(img_orig,1);
img_width = size(img_orig,2);

for y=1:img_height
    for x=1:thickness
        img_orig(y,x) = colour;
    end
    for x=img_width-thickness:img_width
        img_orig(y,x) = colour;
    end
end
for x=1:img_width
    for y=1:thickness
        img_orig(y,x) = colour;
    end
    for y=img_height-thickness:img_height
        img_orig(y,x) = colour;
    end
end

new_img = img_orig;