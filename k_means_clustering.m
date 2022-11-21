clear;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\2109\2022_09_21_11_10_02_55.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));

[L,Centers] = imsegkmeans(I,3);
B = labeloverlay(I,L);
imshow(B)