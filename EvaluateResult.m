function [metrics] = EvaluateResult(result_img, img_name)

% images are expected to have dark background and mark filaments as white
% flocs

labeled_img = imread(append('C:\Users\phili\OneDrive\Dokumente\HS_Mannheim\Masterarbeit\Messungen\Labeled_Data\Daten\Labeled\', img_name));

disp(size(result_img));
disp(size(labeled_img));
sizes_differ = not(size(result_img,1:2) == size(labeled_img,1:2));
if sizes_differ
    disp("image sizes differ");
    return
end

%red
R = 236;
G = 28;
B = 36;

counter_label = 0;
for y=1:size(labeled_img, 1)
    for x=1:size(labeled_img,2)
        if labeled_img(y,x,1) == R && labeled_img(y,x,2) == G && labeled_img(y,x,3) == B
            labeled_img(y,x,:) = 255;
            counter_label = counter_label + 1;
        else
            labeled_img(y,x,:) = 0;
        end
    end
end
%figure, imshow(labeled_img);

TP = result_img & labeled_img;
FP = result_img & not(labeled_img);
TN = not(result_img) & not(labeled_img);
FN = not(result_img) & labeled_img;

TP = sum(TP(:));
FP = sum(FP(:));
TN = sum(TN(:));
FN = sum(FN(:));

sensitivity = TP/(TP + FN);
specitifity = TN/(TN + FP);
precision = TP/(TP + FP);
FNR = FN/(TP + FN);
accuracy = TP + TN / (TP + TN + FP + FN);

disp("sensitivity: " + sensitivity + "\n" + ...
      "specitifity: " + specitifity + "\n" + ...
      "precision: " + precision + "\n" + ...
      "FNR: " + FNR + "\n" + ...
      "accuracy: " + accuracy + "\n");

counter_result = sum(result_img(:));
rel_pixelcount = counter_result / counter_label;

eval = struct;
eval.sensitivity = sensitivity;
eval.specifity = specitifity;
eval.precision = precision;
eval.FNR = FNR;
eval.accuracy = accuracy;
eval.rel_pixelcount = rel_pixelcount;

metrics = eval;