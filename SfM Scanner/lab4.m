
clearvars,
close all,
clc,

addpath('./temple/');

images_ = 40:75;
images = cell(numel(images_), 1);

showSURFfeatures = 0;
showRANSACinliers = 0;

for i=1:numel(images_)
    images{i} = imrotate(rgb2gray(imread(strcat('./temple/temple', num2str(images_(i),'%04d'),'.png'))), 90);
end

matchedPoints = surfFeatures(images);

if showSURFfeatures
    for i=1:numel(images)-1
        figure(1);ax = axes; 
        showMatchedFeatures(images{i},images{i+1},matchedPoints{i}{1},matchedPoints{i}{2},'montage','Parent', ax);
        pause(0.1);
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
        warning('aaaaaaaa');
    end
end

if showRANSACinliers
    for i=1:numel(matchedPoints)
        RANSACinliers1 = matchedPoints{i}{1}.Location;RANSACinliers1 = RANSACinliers1(inliers{i},:);
        RANSACinliers2 = matchedPoints{i}{2}.Location;RANSACinliers2 = RANSACinliers2(inliers{i},:);
        figure(1);ax = axes; 
        showMatchedFeatures(images{i},images{i+1},RANSACinliers1, RANSACinliers2,'montage','Parent', ax);
        pause(0.1);
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


warning off;

P = cell(numel(F)+1,1);
P{1} = eye(3,4);

for i=1:numel(F)
    P{i+1} = vgg_P_from_F(F{i});
    [K, R, t] = vgg_KR_from_P(P{i+1}); 
    %figure(23), scatter3(t(1),t(2),t(3));
    hold on
%     plot3 de X i comprovar que el shape doni bé
end
[K, R, t] = vgg_KR_from_P(P{1}); 
%figure(23), scatter3(t(1),t(2),t(3));



for p=1:numel(F)
    RANSACinliers1 = matchedPoints{p}{1}.Location;RANSACinliers1 = RANSACinliers1(inliers{p},:);
    RANSACinliers2 = matchedPoints{p}{2}.Location;RANSACinliers2 = RANSACinliers2(inliers{p},:);
    [RANSACinliers1(1,:),1]*F{p}* [RANSACinliers2(1,:),1]'
    for i=1:size(RANSACinliers1, 1)
        imsize = [size(images{1},2), size(images{1},1)];
        X = vgg_X_from_xP_lin([RANSACinliers1(i,:); RANSACinliers2(i,:)],{P{p},P{p+1}},[imsize; imsize]);
        scatter3(X(1),X(2),X(3));
        hold on
    end
end
hold off




% 
% for i=1:numel(E)
%     figure(2);
%     [U,S,V] = svd(E{i});
% 
%     T = U*[0,1,0;-1,0,0;0,0,0]*transpose(U);
%     R = U*[0,1,0;-1,0,0;0,0,1]*transpose(V);
%     scatter3(T(3,2),T(1,3),T(2,1));
%     
%     hold on
% end
% hold off
% 
% F = Fm;
% 
% 
% for i=1:numel(matchedPoints)
%    E{i} = transpose(inv(K)) * F{i} * K; 
% end
% 
% 
% for i=1:numel(E)
%     figure(3);
%     [U,S,V] = svd(E{i});
% 
%     T = U*[0,1,0;-1,0,0;0,0,0]*transpose(U);
%     R = U*[0,1,0;-1,0,0;0,0,1]*transpose(V);
%     scatter3(T(3,2),T(1,3),T(2,1));
%     
%     hold on
% end
% 
% hold off



%matlab essential matrix estimation

% Em = {numel(matchedPoints)};
% 
% for i=1:numel(matchedPoints)
%    RANSACinliers1 = matchedPoints{i}{1}.Location;RANSACinliers1 = RANSACinliers1(inliers{i},:);
%    RANSACinliers2 = matchedPoints{i}{2}.Location;RANSACinliers2 = RANSACinliers2(inliers{i},:);
%    Em{i} = estimateEssentialMatrix(RANSACinliers1, RANSACinliers2, K);
% end
% 
% for i=1:numel(E)
%     figure(3);
%     [U,S,V] = svd(Em{i});
%     
%     T = U*[0,1,0;-1,0,0;0,0,0]*transpose(U);
%     R = U*[0,1,0;-1,0,0;0,0,1]*transpose(V);
%     
%     disp(strcat(num2str(T(3,2)),',',num2str(T(1,3)),',',num2str(T(2,1))));
%     scatter3(T(3,2),T(1,3),T(2,1));
%     
%     hold on
% end
% 



