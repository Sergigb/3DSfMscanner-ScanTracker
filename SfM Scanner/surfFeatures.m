
%extracts features between each pair of consecutive images

function features = surfFeatures(images)

features = {numel(images)};

for i=1:numel(images)-1
    points1 = detectSURFFeatures(images{i}); points2 = detectSURFFeatures(images{i+1}); %SURF feature detection
    [features1,valid_points1] = extractFeatures(images{i},points1, 'Method', 'Auto', 'SURFSize', 64);   %SURF feature extraction
    [features2,valid_points2] = extractFeatures(images{i+1},points2, 'Method', 'Auto', 'SURFSize', 64); %SURF feature extraction
    indexPairs = matchFeatures(features1, features2, 'Method', 'Approximate');  %Feature matching (in pairs)
    
    matchedPoints{1} = valid_points1(indexPairs(:,1),:);matchedPoints{2} = valid_points2(indexPairs(:,2),:);
    features{i} = matchedPoints;
end

end