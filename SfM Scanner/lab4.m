
clearvars,
close all,
clc,

addpath('./temple/');

images_ = 7:12;
images = cell(numel(images_), 1);

showSURFfeatures = 1;
showRANSACinliers = 1;

for i=1:numel(images_)
    images{i} = imrotate(rgb2gray(imread(strcat('./temple/temple', num2str(images_(i),'%04d'),'.png'))), 90);
end

matchedPoints = surfFeatures(images);

if showSURFfeatures
    for i=1:numel(images)-1
        figure(1);ax = axes; 
        showMatchedFeatures(images{i},images{i+1},matchedPoints{i}{1},matchedPoints{i}{2},'montage','Parent', ax);
        pause(0.2);
    end
    pause(0.8);
    close all
end

F = {numel(matchedPoints)};
inliers = {numel(matchedPoints)};

for i = 1:numel(matchedPoints)
    try
        image1Coords = matchedPoints{i}{1}.Location';
        image2Coords = matchedPoints{i}{2}.Location';
        [F{i}, inliers{i}] = ransacfitfundmatrix7(image1Coords, image2Coords, 0.01);
    catch
        warning('ransac fucked up');
    end
end


if showRANSACinliers
    for i=1:numel(matchedPoints)
        RANSACinliers1 = matchedPoints{i}{1}.Location;RANSACinliers1 = RANSACinliers1(inliers{i},:);
        RANSACinliers2 = matchedPoints{i}{2}.Location;RANSACinliers2 = RANSACinliers2(inliers{i},:);
        figure(1);ax = axes; 
        showMatchedFeatures(images{i},images{i+1},RANSACinliers1, RANSACinliers2,'montage','Parent', ax);
        pause(0.2);
    end
    pause(0.8)
    close all
end

%%%%%%% INTRINSIC CAMERA PARAMETERS (K)
K = [1520.400000 0.000000    302.320000 
     0.000000    1525.900000 246.870000 
     0.000000    0.000000    1.000000];

%Essential matrixes
E = {numel(matchedPoints)};

for i=1:numel(matchedPoints)
   E{i} = transpose(inv(K)) * F{i} * K; 
end



for i=1:numel(E)
    figure(2);
    [U,S,V] = svd(E{i});
    
    T = U*[0,1,0;-1,0,0;0,0,0]*transpose(U);
    R = U*[0,1,0;-1,0,0;0,0,1]*transpose(V);
    
    disp(strcat(num2str(T(3,2)),',',num2str(T(1,3)),',',num2str(T(2,1))));
    scatter3(T(3,2),T(1,3),T(2,1));
    
    hold on
end







