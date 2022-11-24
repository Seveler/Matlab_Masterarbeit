ending = ".tiff";

[filename,path] = uigetfile('*' + ending, 'Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\1.tiff');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,filename)]);
end
img_orig = imread(fullfile(path,filename));
figure, imshow(img_orig);