clear;
close all;

imagefiles = dir('..\Messungen\selfdrawn\*.png');
%start_file = 1;
nfiles = size(imagefiles,1);

% for i=1:nfiles
%     I = imread(append('..\Messungen\selfdrawn\', imagefiles(i).name));
%     figure, imshow(I(:,:,1));
% end


% [dbfile,path] = uigetfile('*.png','Select an icon file','..Messungen\sefldrawn\fila1.png');
% if isequal(dbfile,0)
%    disp('User selected Cancel');
% else
%    disp(['User selected ', fullfile(path,dbfile)]);
% end
% I = imread(fullfile(path,dbfile));
%% compare form-descriptors


% forms{x} = [0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0;
%             0,0,0,0,0,0,0,0,0,0];

forms{1} = [0,0,0,0,0,0,0,0,0,0;
            1,1,1,0,0,0,0,0,0,0;
            0,0,0,1,0,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,0,1,0,0,0,0;
            0,0,0,0,0,1,0,0,0,1;
            0,0,0,0,0,0,1,1,1,0];
%figure, imshow(forms{1});

forms{2} = [0,0,0,0,0,0,0,0,0,0;
            1,1,1,0,0,0,0,0,0,0;
            0,0,0,1,0,0,0,1,1,1;
            0,0,0,0,1,0,1,0,0,0;
            0,0,0,0,1,1,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,0,1,0,0,0,0;
            0,0,0,0,0,1,0,0,0,1;
            0,0,0,0,0,0,1,1,1,0];
%figure, imshow(forms{2});

forms{3} = [0,0,1,1,1,0,0,0,0,0;
            0,0,0,0,0,1,0,0,0,0;
            0,0,0,0,0,0,1,0,0,0;
            0,0,0,0,0,0,1,0,0,0;
            0,0,0,0,0,0,0,1,0,0;
            0,0,0,0,0,0,0,1,0,0;
            0,0,0,0,0,0,0,1,0,0;
            0,0,0,0,0,0,1,0,0,0;
            0,0,1,1,1,1,0,0,0,0;
            0,1,0,0,0,0,0,0,0,0];
%figure, imshow(forms{3});

forms{4} = [0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0;
            0,0,0,0,1,1,0,0,0,0;
            0,0,0,0,1,1,1,0,0,0;
            0,0,0,0,1,1,1,0,0,0;
            0,0,0,0,1,1,1,0,0,0;
            0,0,0,0,0,1,1,0,0,0;
            0,0,0,0,0,1,1,0,0,0;
            0,0,0,0,1,1,0,0,0,0;
            0,0,0,0,1,0,0,0,0,0];
%figure, imshow(forms{4});

forms{5} = [0,0,0,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,1,0,0;
            0,0,0,0,0,0,1,0,0,0;
            0,0,0,0,0,1,1,0,0,0;
            0,0,0,0,1,1,0,0,0,0;
            0,0,1,1,1,0,0,0,0,0;
            0,0,0,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0,0,0;
            0,0,0,0,0,0,0,0,0,0];
figure, imshow(forms{5});


num_images = size(forms,2);
Circularity = double(num_images);
Eccentricity = double(num_images);
Orientation = double(num_images);
Perimeter_per_Area = double(num_images);
RG = double(num_images);
distances = double(num_images);
Perimeter_distance_per_Area = double(num_images);

for i=1:nfiles
    img = imread(append('..\Messungen\selfdrawn\', imagefiles(i).name));
    img = img(:,:,1);
    img = imcomplement(img);
    %img = forms{5};
    %figure, imshow(img);
    connected_objects = bwconncomp(img,8); %forms{1,i}
    stats = regionprops(connected_objects,"Circularity","Eccentricity", "Area","Perimeter","Orientation");

    Circularity(i) = stats.Circularity;
    Eccentricity(i) = stats.Eccentricity;
    Orientation(i) = stats.Orientation;
    Perimeter_per_Area(i) = stats.Perimeter / stats.Area;
    RG(i) = ReducedRadiusOfGyration(img);

    img = imcomplement(img);
    [D,idx] = bwdist(img);
    distances(i) = max(D(:));

    Perimeter_distance_per_Area(i) = stats.Perimeter*distances(i) / stats.Area;
end

field1 = 'Circularity';  value1 = {Circularity(1,1),Circularity(1,2),Circularity(1,3),Circularity(1,4),Circularity(1,5),Circularity(1,6),Circularity(1,7),Circularity(1,8),Circularity(1,9),Circularity(1,10),Circularity(1,11),Circularity(1,12),Circularity(1,13),Circularity(1,14),Circularity(1,15),Circularity(1,16),Circularity(1,17),Circularity(1,18),Circularity(1,19),Circularity(1,20)};
field2 = 'Eccentricity';  value2 = {Eccentricity(1,1),Eccentricity(1,2),Eccentricity(1,3),Eccentricity(1,4),Eccentricity(1,5),Eccentricity(1,6),Eccentricity(1,7),Eccentricity(1,8),Eccentricity(1,9),Eccentricity(1,10),Eccentricity(1,11),Eccentricity(1,12),Eccentricity(1,13),Eccentricity(1,14),Eccentricity(1,15),Eccentricity(1,16),Eccentricity(1,17),Eccentricity(1,18),Eccentricity(1,19),Eccentricity(1,20)};
field3 = 'distance';  value3 = {distances(1,1),distances(1,2),distances(1,3),distances(1,4),distances(1,5),distances(1,6),distances(1,7),distances(1,8),distances(1,9),distances(1,10),distances(1,11),distances(1,12),distances(1,13),distances(1,14),distances(1,15),distances(1,16),distances(1,17),distances(1,18),distances(1,19),distances(1,20)};
field4 = 'peri_distance_per_area';  value4 = {Perimeter_distance_per_Area(1,1),Perimeter_distance_per_Area(1,2),Perimeter_distance_per_Area(1,3),Perimeter_distance_per_Area(1,4),Perimeter_distance_per_Area(1,5),Perimeter_distance_per_Area(1,6),Perimeter_distance_per_Area(1,7),Perimeter_distance_per_Area(1,8),Perimeter_distance_per_Area(1,9),Perimeter_distance_per_Area(1,10),Perimeter_distance_per_Area(1,11),Perimeter_distance_per_Area(1,12),Perimeter_distance_per_Area(1,13),Perimeter_distance_per_Area(1,14),Perimeter_distance_per_Area(1,15),Perimeter_distance_per_Area(1,16),Perimeter_distance_per_Area(1,17),Perimeter_distance_per_Area(1,18),Perimeter_distance_per_Area(1,19),Perimeter_distance_per_Area(1,20)};
field5 = 'peri_per_area'; value5 = {Perimeter_per_Area(1,1),Perimeter_per_Area(1,2),Perimeter_per_Area(1,3),Perimeter_per_Area(1,4),Perimeter_per_Area(1,5),Perimeter_per_Area(1,6),Perimeter_per_Area(1,7),Perimeter_per_Area(1,8),Perimeter_per_Area(1,9),Perimeter_per_Area(1,10),Perimeter_per_Area(1,11),Perimeter_per_Area(1,12),Perimeter_per_Area(1,13),Perimeter_per_Area(1,14),Perimeter_per_Area(1,15),Perimeter_per_Area(1,16),Perimeter_per_Area(1,17),Perimeter_per_Area(1,18),Perimeter_per_Area(1,19),Perimeter_per_Area(1,20)};
field6 = 'RRG'; value6 = {RG(1,1),RG(1,2),RG(1,3),RG(1,4),RG(1,5),RG(1,6),RG(1,7),RG(1,8),RG(1,9),RG(1,10),RG(1,11),RG(1,12),RG(1,13),RG(1,14),RG(1,15),RG(1,16),RG(1,17),RG(1,18),RG(1,19),RG(1,20)};

summary = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6);