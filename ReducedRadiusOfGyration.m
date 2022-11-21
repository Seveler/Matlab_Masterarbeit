function [RRG_return] = ReducedRadiusOfGyration(img)

dim_imgs = size(img);
[L,N] = bwlabel(img,8); % isolates each object present in image
obj_centroids = regionprops(L, 'Centroid'); % centroids of each object
obj_diameters = regionprops(L, 'EquivDiameter'); % equiv.diameter of " "
obj_listPixels = regionprops(L,'PixelIdxList'); % list of white pixels 
RG = zeros(N,1); %vector containing values R.R.G. for each obj.
for i = 1:N    
    % coordinates (x,y) of each pixel composing the object
    [pixels_y,pixels_x] = ind2sub(dim_imgs,obj_listPixels(i).PixelIdxList);   
    % computes distance between each pixel and the obj.'s centroid
    sum_x = sum( (pixels_x - obj_centroids(i,1).Centroid(1,1)).^2 );
    sum_y = sum( (pixels_y - obj_centroids(i,1).Centroid(1,2)).^2 );
    % computes the moments in each axis
    M2x = sum_x/length(pixels_x);
    M2y = sum_y/length(pixels_y);
    % computes the R.R.G.
    RG(i) = sqrt(M2x + M2y) / (obj_diameters(i).EquivDiameter ./2);     
end

RRG_return = RG;