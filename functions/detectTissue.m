function [mask, noiseMask, artifactBoundry] = detectTissue(img)
logIntensity = log(img);
mask = imfill(logIntensity > mean(logIntensity(:)),'holes');
noiseMask = mask<1;
CC = bwconncomp(mask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,idx] = max(numPixels);
iTemp = zeros(size(logIntensity,1), size(logIntensity,2));
iTemp(CC.PixelIdxList{idx})=1;
mask = iTemp;
% Remove artifact at the top of the image
artifactBound = 60; % Assuming the artifact is above this region
artifactBoundBuff = 3; % Assuming the artifact is above this region
artifactBound = find(sum(mask(1:artifactBound,:),2) == size(mask,2),1,'last');
mask(1:artifactBound+artifactBoundBuff,:) = 0;
artifactBoundry = artifactBound+artifactBoundBuff;
