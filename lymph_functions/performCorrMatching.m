function res = performCorrMatching(I)
% parameters
% thr = 1000;
frameNum = size(I,3);
zSize = size(I,1);
xSize = size(I,2);
load binary_template;
template = template{2};
res = zeros(size(I));
for frameInd = 1:frameNum
    tx = size(template,2);
    ty = size(template,1);    
    a = I(:,:,frameInd);
    res_ = xcorr2(a-mean(a(:)),template-mean(template(:)));    
    res(:,:,frameInd) = res_((ty/2):end-(ty/2),(tx/2):end-(tx/2));
end
for frameInd = 1:xSize
    tx = size(template,2);
    ty = size(template,1);    
    a = squeeze(I(:,frameInd,:));
    res_ = xcorr2(a-mean(a(:)),template-mean(template(:)));    
    res(:,frameInd,:) = res(:,frameInd,:) + permute(res_((ty/2):end-(ty/2),(tx/2):end-(tx/2)),[1,3,2]);
end
% res = res - thr;
% res(res<0) = 0;
% figure; imagesc(squeeze(mean(res,1))); axis image;  title('lymph mean projection'); colormap gray;
% figure; imagesc(squeeze(max(res,[],1))); axis image;  title('lymph max projection'); colormap gray;

