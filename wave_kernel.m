clear;
close all;

[dbfile,path] = uigetfile('*.bmp','Select an icon file','..\Messungen\Mai\1705_klaeranlage_tubus_2.7\2022_05_17_15_36_27_96.bmp');
if isequal(dbfile,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,dbfile)]);
end

I = imread(fullfile(path,dbfile));
figure, imshow(I);
I_size = size(I);
img_height = I_size(1);
img_width = I_size(2);
I = imadjust(I);
figure, imshow(I);

high_kernel = [1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50;
               1/50,1/100,1/150,1/200,1/230,1/230,1/200,1/150,1/100,1/50];
    
kernel_size = size(high_kernel);
num_factors = kernel_size(1)*kernel_size(2);
I = imfilter(I,high_kernel);

for y=1:img_height
    for x=1:img_width
        if(I(y,x) > num_factors-3 && I(y,x) < num_factors+3)
            I(y,x) = 1;
        else
            I(y,x) = 0;
        end
    end
end
I = logical(I);
figure, imshow(I);