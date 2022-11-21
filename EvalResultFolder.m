% call the function, that should be evaluated in line 32 and make sure the
% function returns a binary image with white lines as filaments
% the function skeletonizeDexi() can be used to skeletonize a binary image

clear;
close all;

folderpath = "C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Masterarbeit\Messungen\Labeled_Data\Daten\Original\";
imagefiles = dir(folderpath + "*.tiff");
nfiles = 100; %length(imagefiles);
start_file = 1;

%red
    R = 236;
    G = 28;
    B = 36;

TP = zeros(nfiles,1);
FP = zeros(nfiles,1);
TN = zeros(nfiles,1);
FN = zeros(nfiles,1);

sensitivity = zeros(nfiles,1);
specificity = zeros(nfiles,1);
precision = zeros(nfiles,1);
FNR = zeros(nfiles,1);
FPR = zeros(nfiles,1);
accuracy = zeros(nfiles,1);
rel_pixelcount = zeros(nfiles,1);
counter_result = zeros(nfiles,1);
counter_label = zeros(nfiles,1);
err = zeros(nfiles,1);
se = strel('disk',3);

for i=start_file:start_file + nfiles - 1
    I = imread(append(folderpath, imagefiles(i).name));
    % ENTER FUNCTION NAME
    result_img = getDexiImage(imagefiles(i).name);
    
    result_img_dilated = imdilate(result_img,se);
    %figure, imshow(result_img_dilated);
    counter_result(i) = sum(result_img(:));
    labeled_img = imread(append('C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Masterarbeit\Messungen\Labeled_Data\Daten\Labeled\', imagefiles(i).name));
    labeled_img_dilated = imdilate(labeled_img,se);
    %figure, imshow(labeled_img_dilated);

    sizes_differ = not(size(result_img,1:2) == size(labeled_img,1:2));
    if sizes_differ
        disp("image sizes differ");
        return
    end
    sizes = size(labeled_img);

    % skip images which dont contain any labled pixels (since next loop
    % doesnt work otherwise
    if size(sizes,2) ~= 3
        continue
    end

    %counter_label = 0;
    for y=1:size(labeled_img, 1)
        for x=1:size(labeled_img,2)
            if labeled_img(y,x,1) == R && labeled_img(y,x,2) == G && labeled_img(y,x,3) == B
                labeled_img(y,x,:) = 255;
                counter_label(i) = counter_label(i) + 1;
            else
                labeled_img(y,x,:) = 0;
            end
        end
    end
    %figure, imshow(labeled_img);

    TP_img = result_img_dilated & labeled_img;
    FP_img = result_img & not(labeled_img_dilated);
    TN_img = not(result_img) & not(labeled_img_dilated);
    FN_img = not(result_img_dilated) & labeled_img;
    
    TP(i) = sum(TP_img(:));
    FP(i) = sum(FP_img(:));
    TN(i) = sum(TN_img(:));
    FN(i) = sum(FN_img(:));

    sensitivity(i) = TP(i)/(TP(i) + FN(i)); %recall
    specificity(i) = TN(i)/(TN(i) + FP(i));
    precision(i) = TP(i)/(TP(i) + FP(i));
    FNR(i) = FN(i)/(TP(i) + FN(i));
    FPR(i) = FP(i)/(FP(i) + TN(i));
    accuracy(i) = TP(i) + TN(i) / (TP(i) + TN(i) + FP(i) + FN(i));
    
    rel_pixelcount(i) = counter_result(i) / counter_label(i);
    err(i) = counter_result(i) - counter_label(i);
end

MAE = sum(err(:))/size(err,1);
MedianAE = median(err(:));
std_deviation = std(err);

figure, plot(1:size(rel_pixelcount, 1),rel_pixelcount(:,1),'linestyle','none','marker','x')
figure, plot(1:size(err, 1),err(:,1),'linestyle','none','marker','x')
figure, plot(1:size(sensitivity, 1),sensitivity(:,1),'linestyle','none','marker','x')
figure, plot(1:size(FPR, 1),FPR(:,1),'linestyle','none','marker','x')