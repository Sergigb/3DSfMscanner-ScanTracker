%%test

addpath('./temple/');
im1 = imread('temple0011.png');
im2 = imread('temple0075.png');

im1= rgb2gray(im1);
im2= rgb2gray(im2);

im1 = imrotate(im1, 90);
im2 = imrotate(im2, 90);

points1 = detectSURFFeatures(im1); points2  = detectSURFFeatures(im2);

[features1,valid_points1] = extractFeatures(im1,points1, 'Method', 'Auto', 'SURFSize', 64);
[features2,valid_points2] = extractFeatures(im2,points2, 'Method', 'Auto', 'SURFSize', 64);
indexPairs = matchFeatures(features1, features2, 'Method', 'Approximate');
matchedPoints1 = valid_points1(indexPairs(:,1),:);matchedPoints2 = valid_points2(indexPairs(:,2),:);
%figure; showMatchedFeatures(im1,im2,matchedPoints1,matchedPoints2);
figure(2);ax = axes; showMatchedFeatures(im1,im2,matchedPoints1,matchedPoints2,'montage','Parent', ax);

