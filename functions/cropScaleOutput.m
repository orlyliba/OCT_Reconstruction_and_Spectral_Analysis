function [linBscanResize,diffImg,compoundImg,linBscan,speckVarNorm] = cropScaleOutput(viewRange,trueToScale,reSizeMethod,pixX,pixZ,linBscan,diffImg,compoundImg,speckVarNorm)

linBscan = linBscan(viewRange,:,:);
linBscanResize = linBscan;
if ~isempty(diffImg)
    diffImg = diffImg(viewRange,:,:);
end
if ~isempty(compoundImg)
    compoundImg = compoundImg(viewRange,:,:);
end
if ~isempty(speckVarNorm)
    speckVarNorm = speckVarNorm(viewRange,:,:);
end

if trueToScale
    if pixX > pixZ
        linBscanResize = imresize(linBscan,[size(linBscan,1) size(linBscan,2)*pixX/pixZ],reSizeMethod);
        if ~isempty(diffImg)
            diffImg = imresize(diffImg,[size(diffImg,1) size(diffImg,2)*pixX/pixZ],reSizeMethod);
        end
        if ~isempty(compoundImg)
            compoundImg = imresize(compoundImg,[size(compoundImg,1) size(compoundImg,2)*pixX/pixZ],reSizeMethod);
        end
        if ~isempty(speckVarNorm)
            speckVarNorm = imresize(speckVarNorm,[size(speckVarNorm,1) size(speckVarNorm,2)*pixX/pixZ],reSizeMethod);
        end
    else
        linBscanResize = imresize(linBscan,[size(linBscan,1)*pixZ/pixX size(linBscan,2)],reSizeMethod);
        if ~isempty(diffImg)
            diffImg = imresize(diffImg,[size(diffImg,1)*pixZ/pixX size(diffImg,2)],reSizeMethod);
        end
        if ~isempty(compoundImg)
            compoundImg = imresize(compoundImg,[size(compoundImg,1)*pixZ/pixX size(compoundImg,2)],reSizeMethod);
        end
        if ~isempty(speckVarNorm)
            speckVarNorm = imresize(speckVarNorm,[size(speckVarNorm,1)*pixZ/pixX size(speckVarNorm,2)],reSizeMethod);
        end
    end
end