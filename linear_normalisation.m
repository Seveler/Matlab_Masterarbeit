function [img_return] = linear_normalisation(img_orig)

img_height = size(img_orig,1);
img_width = size(img_orig,2);

oldmin = min(img_orig(:));
oldmax = max(img_orig(:));
oldrange = oldmax-oldmin;

newmin = 0;
newmax = 255;
newrange = newmax-newmin;

for y=1:img_height
    for x=1:img_width
        scale=(img_orig(y,x)-oldmin)/oldrange;
        img_orig(y,x) = (newrange*scale)+newmin;
    end
end
img_return = img_orig;




