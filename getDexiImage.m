function [new_img] = getDexiImage(filename)
 
% clear;
% close all;

ending = ".tiff";

% [filename,path] = uigetfile('*' + ending, 'Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\140.tiff');
% if isequal(filename,0)
%    disp('User selected Cancel');
% else
%    disp(['User selected ', fullfile(path,filename)]);
% end
% img_orig = imread(fullfile(path,filename));
%figure, imshow(img_orig);

img_orig = imread(append('..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\', filename));

png = erase(filename,ending) + ".png";
dexi_img = imread(append('..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\outputs\', png));
%figure, imshow(dexi_img);

new_img = skeletonizeDexi(dexi_img);
%figure, imshow(new_img);

%% close triangles in edge areas
endpoints = bwmorph(new_img, "endpoints");
[row,col] = find(endpoints);
img_height = size(endpoints,1);
img_width = size(endpoints,2);
drawn_lines = zeros(img_height,img_width); % set true for locations of added pixellines
for pixel=1:size(row,1)
    for tolerance=0:1
        if(row(pixel) == 1 + tolerance || row(pixel) == img_height - tolerance) % only consider endpoints close to image's edge
            dist_to_horizontal_edge = img_width-col(pixel);
            if(dist_to_horizontal_edge > 200)
                range = 200;
            else
                range = dist_to_horizontal_edge;
            end
            % search for second endpoint on same row
            for d=1:range 
                if(endpoints(row(pixel),col(pixel)+d) == 1)
                    for draw=1:+d
                        endpoints(row(pixel),col(pixel)+draw) = 1;
                        drawn_lines(row(pixel),col(pixel)+draw) = 1;
                    end
                end
                continue;
            end
        end
    end
end
for pixel=1:size(col,1)
    for tolerance=1:2
        if(col(pixel) == 1 + tolerance || col(pixel) == img_width - tolerance)
            dist_to_vertical_edge = img_height-row(pixel);
            if(dist_to_vertical_edge > 200)
                range = 200;
            else
                range = dist_to_vertical_edge;
            end
            % search for second endpoint on same column
            for d=1:range 
                if(endpoints(row(pixel)+d,col(pixel)) == 1)
                    for draw=1:+d
                        endpoints(row(pixel)+draw,col(pixel)) = 1;
                        drawn_lines(row(pixel)+draw,col(pixel)) = 1;
                    end
                end
                continue;
            end
        end
    end
end
new_img = endpoints | new_img;
%figure, imshow(new_img);

% fill holes and remove closed objects

holes = imfill(new_img,"holes");
%figure, imshow(holes);
branchpoints = bwmorph(new_img,"branchpoints");
holes_without_branchpoints = holes & ~(branchpoints);
rm_filaments = bwareaopen(holes_without_branchpoints,100,4);
rm_holes = new_img & ~rm_filaments;
rm_holes = bwareaopen(rm_holes,10,8);
new_img = rm_holes;
%figure, imshow(rm_holes);
new_img = colour_image_border(new_img, 8, 0);
%figure, imshow(new_img);

%% compare filament length and filaments endpoint distances

% get endpoints of objects, that only contain of two endpoints
% endpoints = bwmorph(new_img, "endpoints");
% [row,col] = find(endpoints);
% endpoint_index = sub2ind(size(endpoints),row,col);
for repeat=1:2

branchpoints = bwmorph(new_img,"branchpoints");
new_img = new_img & ~branchpoints;
%figure, imshow(new_img);
connected_objects = bwconncomp(new_img,8);
endpoints = bwmorph(new_img, "endpoints");
[row,col] = find(endpoints);
endpoint_index = sub2ind(size(endpoints),row,col);

% new_img = uint8(new_img);
% new_img = new_img * 255;
% red = new_img;
% %red(:) = 0;
% green = new_img;
% %green(:) = 0;
% blue = new_img;
% %blue(:) = 0;
% out_image = cat(3, red, green, blue);
% %figure, imshow(out_image);


formdescriptor = zeros(connected_objects.NumObjects,1);
for i=1:connected_objects.NumObjects    % for every object
    len = size(connected_objects.PixelIdxList{1,i});
    len = len(1);
    counter_endpoints = 0;
    pixelindex = [0,0; 0,0];
    pixellist = connected_objects.PixelIdxList{1, i};
    num_endpoints = size(row,1);
    for pixelnum=1:num_endpoints % interate over all endpoints
        if ismember(endpoint_index(pixelnum), pixellist)
            counter_endpoints = counter_endpoints + 1;
            [r,c] = ind2sub(size(endpoints), endpoint_index(pixelnum));
            pixelindex(counter_endpoints,1) = r;
            pixelindex(counter_endpoints,2) = c;
%             out_image(r,c,1) = 255;
%             out_image(r,c,2) = 0;
%             out_image(r,c,3) = 0;
        end
    end
%     %colour filaments red
%     for pixel=1:len
%         [r2,c2] = ind2sub(size(out_image),pixellist(pixel));
%         out_image(r2,c2,1) = 255;
%         out_image(r2,c2,2) = 0;
%         out_image(r2,c2,3) = 0;
%     end
%     figure, imshow(out_image);
    if counter_endpoints == 2 %only lines (two endpoints)
        % determine distance between points and compare to length of filamente
        distance = norm(pixelindex(1,:)-pixelindex(2,:));
        linelength = size(pixellist,1) - 1;
        formdescriptor(i) = distance / linelength;
        if formdescriptor(i) < 0.85
            for pixelnum2=1:len
                new_img(pixellist(pixelnum2)) = 0;
            end
        end
    end
end
new_img = new_img | branchpoints;
%figure, imshow(new_img);
end

%% remove filaments being part of flocs

img_flocs = find_flocs2(img_orig);
%figure, imshow(img_flocs);

se = strel('disk',2);
img_flocs = imclose(img_flocs,se);
%figure, imshow(img_flocs);
img_flocs = imdilate(img_flocs,se);
%figure, imshow(img_flocs);
img_flocs = colour_image_border(img_flocs, 10, 0);
%figure, imshow(img_flocs);
img_flocs = imfill(img_flocs,"holes");
%figure, imshow(img_flocs);

new_img = new_img & ~img_flocs;


%figure, imshow(new_img);