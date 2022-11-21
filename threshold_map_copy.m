clear;
%close all;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\Mai\1705_klaeranlage_tubus_2.7\2022_05_17_15_36_26_21.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
I = imresize(I,0.5);
I_adjusted = imadjust(I);
figure, imshow(I_adjusted);
I_size = size(I_adjusted);
img_height = I_size(1);
img_width = I_size(2);

kernel_vertical = [0,0,0;
                    10,0,-10;
                     0,0,0];
kernel_horizontal = [0,10,0;
                   0,0,0;
                   0,-10,0];

I1 = imfilter(I_adjusted,kernel_horizontal);
I2 = imfilter(I_adjusted,kernel_vertical);
I1 = double(I1);
I2 = double(I2);

I3 = sqrt(I1.^2 + I2.^2);
I = uint8(I3);
figure, imshow(I);
%figure, imshow(I(270:310,110:170))

t_map = imgaussfilt(I,5); %t_map = imgaussfilt(I,10);
figure, imshow(t_map);
%for t_diff=10:10:50
t_diff = 150;
%figure, imshow(t_map);
%t_map = int8(t_map); neu

new_img = zeros(img_height, img_width,'logical');
diff_r = int8(0);
diff_l = int8(0);
diff_o = int8(0);
diff_u = int8(0);
diff_ro = int8(0);
diff_ru = int8(0);
diff_lo = int8(0);
diff_lu = int8(0);

%% compare with threshold map
d = 10;
diffs = zeros(4*2*d - 4,1);
diffs = int8(diffs);

for y=1+d:img_height-d
    for x=1+d:img_width-d
        r = true;
        l = true;
        o = true;
        u = true;
        ro = true;
        ru = true;
        lo = true;
        lu = true;

        diff_r = I(y,x) - t_map(y,x+d);
%         if(diff_r > 0)
%             disp(I(y,x));
%             disp(t_map(y,x+d));
%         end
        diff_l = I(y,x) - t_map(y,x-d);
        diff_o = I(y,x) - t_map(y+d,x);
        diff_u = I(y,x) - t_map(y-d,x);

        diff_ro = I(y,x) - t_map(y+d,x+d);
        diff_ru = I(y,x) - t_map(y-d,x+d);
        diff_lo = I(y,x) - t_map(y+d,x-d);
        diff_lu = I(y,x) - t_map(y-d,x-d);
        
        num_t_diffs = 0;
        %edge_pixels = zeros(4*2*d,2);
        %edge_pixels =uint8.empty;
        

%         index_c = 1;
%         for i=y-d:y+d
%             for j=1:2*d-1:2*d
%                 diffs(index_c) = I(y,x) - t_map(i,j);
%                 index_c = index_c + 1;
%             end
%         end
%         for j=x-d+1:x+d-1 
%             for i=1:2*d-1:2*d
%                 diffs(index_c) = I(y,x) - t_map(i,j);
%                 index_c = index_c + 1;
%             end
%         end 


%         diffs = I(y,x) - t_map(edge_pixels);
%         diffs2 = (diffs > t_diff) | (diffs < -t_diff);
%         num_t_diffs = sum(diffs2(:));
        
        if(diff_r > t_diff || diff_r < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            r = false;
        end
        if(diff_l > t_diff || diff_l < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            l = false;
        end
        if(diff_o > t_diff || diff_o < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            o = false;
        end
        if(diff_u > t_diff || diff_u < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            u = false;
        end

        if(diff_ro > t_diff || diff_ro < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            ro = false;
        end
        if(diff_ru > t_diff || diff_ru < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            ru = false;
        end
        if(diff_lo > t_diff || diff_lo < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            lo = false;
        end
        if(diff_lu > t_diff || diff_lu < -t_diff)
            num_t_diffs = num_t_diffs + 1;
            lu = false;
        end
%         if(y==250 && x==670)
%             disp("now");
%         end
        %funktioniert nur mit 4 gut
        if(num_t_diffs > 6) % d+4 >= num_t_diffs || num_t_diffs >= d-4) %&& (r&&l || ru&&lo || u&&o || lu&&ro))
            new_img(y,x) = 1;
        end
    end
end
figure, imshow(new_img);

% %% remove very dark pixels (probably part of floc)
% 
% new_img = new_img & I_adjusted > 50;
% figure, imshow(new_img);
% 
% %% old tests
% % I = bwareafilt(I, [7, 2000], 8); % Keep objects with pixelsize between [ , ]
% % figure, imshow(I);
% % 
% % %% delete non-circular connected objects
% % connected_objects = bwconncomp(I,4);
% % stats = regionprops(connected_objects,"Eccentricity");
% % 
% % for i=1:connected_objects.NumObjects
% %     if(stats(i).Eccentricity < 0.95)
% %         % delete object
% %         len = size(connected_objects.PixelIdxList{1,i});
% %         len = len(1);
% %         for pixelnum=1:len
% %             pixel = connected_objects.PixelIdxList{1,i}(pixelnum);
% %             I(pixel) = 0;
% %         end
% %     end
% % end
% % 
% % figure, imshow(I);
%  
% %% connect closest Pixels
% connected_objects = bwconncomp(new_img,8);
% centroids = regionprops(connected_objects,'Centroid');
% datapoints = vertcat(centroids.Centroid);
% 
% for i=1:size(datapoints,1)
%     if(i==size(datapoints,1))
%         help1 = datapoints(1:size(datapoints,1)-1,:);
%         help2 = double.empty;
%         data = cat(1,help1,help2);
%     elseif(i==1)
%         help1 = double.empty;
%         help2 = datapoints(2:size(datapoints,1),:);
%         data = cat(1,help1,help2);
%     else
%         help1 = datapoints(1:i-1,:);
%         help2 = datapoints(i+1,:);
%         data = cat(1,help1,help2);
%     end
%     [closest_point,dist] = dsearchn(data, [datapoints(i,1) datapoints(i,2)]);
%     if(dist < 10)
%         len = size(connected_objects.PixelIdxList{1,closest_point});
%         len = len(1);
%         y = [datapoints(i,2) data(closest_point,2)]; 
%         x = [datapoints(i,1) data(closest_point,1)];
%         nPoints = max(abs(diff(x)), abs(diff(y)))+1;    % Number of points in line
%         rIndex = round(linspace(y(1), y(2), nPoints));  % Row indices
%         cIndex = round(linspace(x(1), x(2), nPoints));  % Column indices
%         index = sub2ind(size(new_img), rIndex, cIndex);     % Linear indices
%         new_img(index) = 255;  % Set the line points to white
%     end
% end
% figure, imshow(new_img);
% 
% %% Reduced radius of gyration
% RG_thresh = 1.0;
% [L,N] = bwlabel(new_img,8); % isolates each object present in image
% obj_centroids = regionprops(L, 'Centroid'); % centroids of each object
% obj_diameters = regionprops(L, 'EquivDiameter'); % equiv.diameter of " "
% obj_listPixels = regionprops(L,'PixelIdxList'); % list of white pixels
% obj_circularity = regionprops(L, 'Circularity'); % composing each obj.
% 
% %stats = regionprops(connected_objects,"Circularity");
% 
% %connected_objects = bwconncomp(new_img,8);
% 
% 
% RG = zeros(N,1); %vector containing values R.R.G. for each obj.
% map_rg = L;
% for i = 1:N    
%     [pixels_y,pixels_x] = ind2sub(I_size,obj_listPixels(i).PixelIdxList);   
%     sum_x = sum( (pixels_x - obj_centroids(i,1).Centroid(1,1)).^2 );
%     sum_y = sum( (pixels_y - obj_centroids(i,1).Centroid(1,2)).^2 );
%     M2x = sum_x/length(pixels_x);
%     M2y = sum_y/length(pixels_y);
%     RG(i) = sqrt(M2x + M2y) / (obj_diameters(i).EquivDiameter ./2);
%     if RG(i) > RG_thresh %&& obj_circularity(i).Circularity < 0.5
%         map_rg(obj_listPixels(i).PixelIdxList) = 1;          
%     else
%         map_rg(obj_listPixels(i).PixelIdxList) = 0;
%     end
% end
% figure, imshow(map_rg);
% %% distance map as form descriptor
% % connected_objects = bwconncomp(I,4);
% % I = imcomplement(I);
% % figure, imshow(I);
% % [D,idx] = bwdist(I);
% % D = 25*D;
% % D = uint8(D);
% % %D = imadjust(D);
% % figure, imshow(D);
% % 
% % for i=1:connected_objects.NumObjects
% %     len = size(connected_objects.PixelIdxList{1,i});
% %     len = len(1);
% %     for pixelnum=1:len
% %         pixel_coordinate = connected_objects.PixelIdxList{1,i}(pixelnum);
% %         if(D(pixel_coordinate) >= 70)
% %             % delete object
% %             disp("delete");
% %             for pixelnum2=1:len
% %                 pixel_coordinate = connected_objects.PixelIdxList{1,i}(pixelnum2);
% %                 I(pixel_coordinate) = 1;
% %             end
% %         end
% %     end
% % end
% % figure, imshow(I);
