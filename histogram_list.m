clear;
close all;

imagefiles = dir('..\Messungen\2109\*.bmp');
start_file = 1;
nfiles = 5; %length(imagefiles);

% I = imread(append('..\Messungen\2109\', imagefiles(start_file).name));
% edges = 0:1:255;
% N = histcounts(I,edges);
% N(256) = 0;
% 
% figure, plot(edges,N);
% 
% N_log = log(N);
% figure, plot(edges,N_log);
% 
% dt_log = diff(N_log);
% figure, plot(edges,N2_log);

for i=1:nfiles
    I = imread(append('..\Messungen\2109\', imagefiles(i+start_file).name));
%     subplot(nfiles,2,2*i-1);
%     imshow(I);
%     subplot(nfiles,2,2*i);
%     h = histogram(I);
%     histogram(log(I));
    I = imadjust(I);
    figure, imshow(I);
end

