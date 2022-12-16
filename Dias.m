clear;
close all;

[dbfile,path] = uigetfile('*.tiff','Select an icon file','..\..\Hiwi\AI-Service\AI-Service\results\DexiNed\Original_2022_11_09 14-06-33\inputs\1.tiff');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = detectFilaments(fullfile(path,dbfile));