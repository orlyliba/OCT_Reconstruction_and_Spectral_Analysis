function iLymph = detectLymph(I,thr)
% thr = 1500;
scale_param = 300;
iH = size(I,1);
iW = size(I,2);
iOCT = I;
[iVoid, iEarVolume] = deal(iOCT);
for i=1:size(I,3)
    [mask, ~, ~] = detectTissue(iOCT(:,:,i));
    iEarVolume(:,:,i) = mask;
    %         figure(100); imagesc(mask); colormap gray; axis image;
end
res = performCorrMatching(I);
iTemplateMatching = res - thr;
iTemplateMatching(iTemplateMatching<0) = 0;

% Filter by masks to get rid of extraneous vessel detection
iLymph = iEarVolume.*iTemplateMatching;
% figure; imagesc(squeeze(max(iLymph,[],1))); axis image; colormap gray; title('maximal projection of Lymph detection')
iLymph = scale_param*(iLymph-min(iLymph(:)))/(max(iLymph(:))-min(iLymph(:)));