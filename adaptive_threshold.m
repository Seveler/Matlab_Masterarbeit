% Ungeeignet. Nur grobe Binarisierung!

clear;
close all;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\Mai\1705_klaeranlage_tubus_2.7\2022_05_17_15_36_27_96.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
%I = imresize(I,0.5);
%I = imadjust(I);
T = adaptthresh(I, 0.1);
figure, imshow(T);
I = imbinarize(T);
figure, imshow(I);