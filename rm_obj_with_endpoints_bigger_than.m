function [result] = rm_obj_with_endpoints_bigger_than(img_orig, thresh_endpoints)

% only works on images composing of skelletons
endpoints = bwmorph(img_orig, "endpoints");
[row,col] = find(endpoints); % get row,col of non-zero values
endpoint_index = sub2ind(size(endpoints),row,col);

connected_objects = bwconncomp(img_orig,8);
for i=1:connected_objects.NumObjects    % for every object
    len = size(connected_objects.PixelIdxList{1,i});
    len = len(1);
    counter_endpoints = 0;
    pixellist = connected_objects.PixelIdxList{1, i};
    num_endpoints = size(row,1);
    for pixelnum=1:num_endpoints % interate over all endpoints
        if ismember(endpoint_index(pixelnum), pixellist)
            counter_endpoints = counter_endpoints + 1;
        end
    end

    if counter_endpoints > thresh_endpoints
        %remove object
        for pixelnum2=1:len
                img_orig(pixellist(pixelnum2)) = 0;
        end
    end
end

result = img_orig;