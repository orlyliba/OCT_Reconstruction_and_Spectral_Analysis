function Buff = createBufferTemplate(viewRange,nAscans, pixX,pixZ, trueToScale,reSizeMethod,outputFrameNum)
Buff = zeros(length(viewRange),nAscans);
if trueToScale
    if pixX > pixZ
        [Buff] = imresize(Buff,[size(Buff,1) size(Buff,2)*pixX/pixZ],reSizeMethod);
    else
        [Buff] = imresize(Buff,[size(Buff,1)*pixZ/pixX size(Buff,2)],reSizeMethod);
    end
end
Buff = repmat(Buff,[1,1,outputFrameNum]);