% http://www.htw-mechlab.de/index.php/kantenerkennung-in-matlab-vergleich-zwischen-canny-algorithmus-und-ternaerer-maske/

bild = imread('img5.bmp');

% high pass
mask = [ 1 0 0; 1 0 0; 1 0 -5; 1 0 0; 1 0 0];
hp_img = imfilter(im2double(bild),mask,'same');
figure; imshow(hp_img,[])

[y,x] = size(hp_img);
edges = edge(hp_img, 'canny', 0.2);
figure; imagesc(edges);
sum(sum(edges))