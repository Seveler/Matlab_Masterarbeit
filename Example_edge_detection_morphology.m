
% Read Image
I = imread("..\Messungen\2109\2022_09_21_11_11_33_48.bmp");
imshow(I)
title('Original Image');
text(size(I,2),size(I,1)+15, ...
    'Testimage', ...
    'FontSize',7,'HorizontalAlignment','right');

% 2
[~,threshold] = edge(I,'sobel');
fudgeFactor = 0.8;
BWs = edge(I,'sobel',threshold * fudgeFactor);
imshow(BWs)
title('Binary Gradient Mask')

% 3
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs,[se90 se0]);
imshow(BWsdil)
title('Dilated Gradient Mask')

% 4
BWdfill = imfill(BWsdil,'holes');
imshow(BWdfill)
title('Binary Image with Filled Holes')

% 5
BWnobord = imclearborder(BWdfill,4);
imshow(BWnobord)
title('Cleared Border Image')

% 6 
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
imshow(BWfinal)
title('Segmented Image');

% 7
imshow(labeloverlay(I,BWfinal))
title('Mask Over Original Image')

BWoutline = bwperim(BWfinal);
Segout = I; 
Segout(BWoutline) = 255; 
imshow(Segout)
title('Outlined Original Image')