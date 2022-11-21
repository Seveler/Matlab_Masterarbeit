clear;

data = load("mat_labeled_Mai/2022_05_17_15_36_27_96.mat");
trainingData = data.gTruth;
[imds,bxds] = objectDetectorTrainingData(trainingData);
cds = combine(imds,bxds);

inputSize = [1088 2048 1];
numClasses = 2;
classes = {'filaments','flocs'};
% trainingDataForEstimation = transform(trainingData,@(data)preprocessData(data,inputSize));
% numAnchors = 7;
% [anchorBoxes, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors);
% 
% featureExtractionNetwork = resnet50;
% featureLayer = 'activation_40_relu';
% lgraph = yolov2Layers(inputSize,numClasses,anchorBoxes,featureExtractionNetwork,featureLayer);

options = trainingOptions('sgdm', ...
       'InitialLearnRate', 0.001, ...
       'Verbose',true, ...
       'MiniBatchSize',16, ...
       'MaxEpochs',30, ...
       'Shuffle','every-epoch', ...
       'VerboseFrequency',10); 

detector = yolov4ObjectDetector("tiny-yolov4-coco");

