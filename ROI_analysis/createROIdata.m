% Code for collecting data from ROIs in Bscans
clear; close all; clc
%%
pathName = '\';
outputPathName = '\';
suffix = '_vessel4';
selectionShape = 'ellips';% ellips, rectangle, polygon
%%
fileName = dir([pathName '*.mat']);

for fileInd  = 1:length(fileName)
    disp(fileName(fileInd).name)
    load([pathName fileName(fileInd).name]);
    if fileInd == 1
        M = size(signalBuff,1);
        N = size(signalBuff,2);
        figure; imagesc(rawSpeckVarBuff); colormap gray; axis image
        switch selectionShape
            case 'ellips'
                h = imellipse;
                vert = wait(h);
                mask = poly2mask(vert(:,1),vert(:,2),M,N);
            case 'polygon'
                [mask, xi, yi] = roipoly;
                vert(:,1) = xi;
                vert(:,2) = yi;
            case 'rectangle'
                rect = getrect;
                vert(:,1) = [rect(1); rect(1)+rect(3)-1; rect(1)+rect(3)-1; rect(1)];
                vert(:,2) = [rect(2); rect(2); rect(2)+rect(4)-1; rect(2)+rect(4)-1;];
                mask = poly2mask(vert(:,1),vert(:,2),M,N);
        end
    end
    % verify ROI location    
    figure; imagesc(signalBuff); colormap gray; axis image
    hold on;
    plot(vert(:,1),vert(:,2),'r','LineWidth',2);
    signalBuff(mask == 0) = [];
    diffNormBuff(mask == 0) = [];
    speckVarBuff(mask == 0) = [];
    diffBuff(mask == 0) = [];
    rawSpeckVarBuff(mask == 0) = [];
    save([outputPathName fileName(fileInd).name(1:end-4) '_ROI' suffix],'signalBuff','diffNormBuff','speckVarBuff','diffBuff','rawSpeckVarBuff')
end
