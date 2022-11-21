clear;
close all;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_09_56_54.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
I = imresize(I,0.5);
figure, imshow(I);

se = strel('disk',12);
BH = imbothat(I,se);
TH = imtophat(I,se);
I = imsubtract(imadd(I,imtophat(I,se)), imbothat(I,se));
%I = imadjust(BH);
figure, imshow(I);
% 
%I = imadjust(TH);
figure, imshow(imadjust(TH));
figure, imshow(imadjust(BH));
