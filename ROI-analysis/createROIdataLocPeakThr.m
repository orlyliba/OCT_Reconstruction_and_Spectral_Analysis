% Code for collecting data from ROIs in Bscans
clear; %close all; %clc
%%
filePath = '\';
fileName = '.mat'; % Buffer output, containing linear or log signal
outputPathName = '\';
suffix = 'sample1';
selectionShape = 'manualrect';% ellips, rectangle, polygon, freehand, manualrect
sigThr = 400; % threshold of the local peak
dilateRegion = 1;
% for manual rect option
w = 230.4698; h = 112.3175; x = 586.1557; y = 409.6638;
%%
disp(fileName)
load([filePath fileName]);
M = size(signalBuff,1);
N = size(signalBuff,2);
[X, Y] = meshgrid(1:N,1:M);
figure; imagesc(log(signalBuff)); colormap gray; axis image; title('log of input signal')
switch selectionShape
    case 'freehand'
        h = imfreehand;
        mask = h.createMask();
        vert = h.getPosition();
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
        disp(['w = ' num2str(rect(3))])
        disp(['h = ' num2str(rect(4))])
        disp(['xy = ' num2str(rect(1)) ',' num2str(rect(2))])
        vert(:,1) = [rect(1); rect(1)+rect(3)-1; rect(1)+rect(3)-1; rect(1); rect(1)];
        vert(:,2) = [rect(2); rect(2); rect(2)+rect(4)-1; rect(2)+rect(4)-1; rect(2)];
        mask = poly2mask(vert(:,1),vert(:,2),M,N);
    case 'manualrect'
        rect = [x y w h];
        disp(['w = ' num2str(rect(3))])
        disp(['h = ' num2str(rect(4))])
        disp(['xy = ' num2str(rect(1)) ',' num2str(rect(2))])
        vert(:,1) = [rect(1); rect(1)+rect(3)-1; rect(1)+rect(3)-1; rect(1); rect(1)];
        vert(:,2) = [rect(2); rect(2); rect(2)+rect(4)-1; rect(2)+rect(4)-1; rect(2)];
        mask = poly2mask(vert(:,1),vert(:,2),M,N);
end
% verify ROI location
figure; 
subplot(1,2,1)
imagesc(log(signalBuff)); colormap gray; axis image
hold on;
plot(vert(:,1),vert(:,2),'r','LineWidth',2); title('region borders')
% 
[map] = findLocalMax(signalBuff,sigThr);
mask = map .* mask;
mask = imdilate(mask,ones(dilateRegion));
%
X(mask == 0) = [];
Y(mask == 0) = [];
subplot(1,2,2); imagesc(log(signalBuff)); colormap gray; axis image; title('peaks')
hold on; plot(X,Y,'.r')
signalBuff(mask == 0) = [];

save([outputPathName fileName(1:end-4) '_ROI_' suffix],'signalBuff','X','Y')
disp(['Mean ' num2str(mean(signalBuff(:)))])
disp(['Standard deviation: ' num2str(std(signalBuff(:)))])
