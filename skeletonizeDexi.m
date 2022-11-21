function [new_img] = skeletonizeDexi(I)

img_area = size(I,1) * size(I,2);
bright_pixels = I > 230;
num_bright_pixels = sum(bright_pixels(:));

if num_bright_pixels > (img_area/2)
    I = imadjust(I);
    I = I < 250;
end

%new_img = bwmorph(I,'skel',inf);
new_img = bwskel(I);

% %% Isolate Skeleton's Spine
% [L,N] = bwlabel(img_thin,8); % isolates each object present in image
% 
% obj_pixelsList = regionprops(L,'PixelIdxList'); % list of white pixels 
%                                                 % composing each obj.
% obj_Images = regionprops(L,'Image');% portraits containing each single obj.
% 
% dim_imgs = size(img_thin); % dimensions X and Y of the image 
% new_img = zeros(dim_imgs); % new image containing processed objects
% lengths = zeros(N,1); % length of each spine (distance of pixels)
% 
% for i = 1:N   % for each object  
%     
%     endpoints = bwmorph(obj_Images(i,1).Image, 'endpoints'); % list of endpoints
%     [y,x] = find(endpoints); % coordinates (x,y) of each endpoint
%     
%     % detection of the four suitable endpoints:       
%     difX = abs(x-size(obj_Images(i,1).Image,2)); % dist. between endpoints and X limit
%     difY = abs(y-size(obj_Images(i,1).Image,1)); % dist. between endpoints and Y limit
%     
%     [~,list_idx(1)] = max(difX(:)); % closest to the left border
%     [~,list_idx(2)] = min(difX(:)); % closest to the right border
%     [~,list_idx(3)] = max(difY(:)); % closest to the top
%     [~,list_idx(4)] = min(difY(:)); % closest to the bottom
%     
%     % vector containing: 
%     % maximal distance between endpoints | starting endpoint | farthest (final) endpoint 
%     maxD = [0 0 0];
%     
%     for endp = 1:4
%         D = bwdistgeodesic(obj_Images(i,1).Image, x(list_idx(endp)),y(list_idx(endp)),'quasi-euclidean');
%         D(isinf(D)) = 0; % attributes 0 to pixels containing infinite value
%         D(isnan(D)) = 0; % attributes 0 to pixels containing non-available value
%         
%         if maxD(1) < max(D(:)) % updates maximal distance between endpoints
%            maxD = [max(D(:)) list_idx(endp) find(D == max(D(:)),1)]; 
%            copyD = D; % retains a copy of the geodesic transform related to 
%                       % the endpoint that is the starting point for this maximal distance
%         end
%         
%     end     
% 
%     [Y,X] = ind2sub(size(D),maxD(3)); % coordinates (x,y) of the farthest endpoint
%     
%     % geodesic transform starting from this farthest endpoint
%     D2 = bwdistgeodesic(obj_Images(i,1).Image, double(X),double(Y), 'quasi-euclidean');
%     D = copyD + D2; % addition of distances calculated in both directions
%     D = round(D * 8) / 8; % rounding values
% 
%     lengths(i,1) = min(D(:)); % update vector containing length of each spine
%     
%     D(isnan(D)) = inf;
%     paths = imregionalmin(D); % detection of shortest path based on region minima
%     
%     % maps each object from its portrait back to the original image
%     [objY,objX] = ind2sub(dim_imgs,obj_pixelsList(i,1).PixelIdxList(1,1));
%     [imY,imX] = find(obj_Images(i,1).Image > 0,1);
%     [pY,pX] = find(paths > 0);     
%     
%     offsetX = objX-imX; offsetY = objY-imY; 
%     
%     id_white = sub2ind(dim_imgs,pY+offsetY,pX+offsetX);
%     new_img(id_white) = 1;
%         
% end