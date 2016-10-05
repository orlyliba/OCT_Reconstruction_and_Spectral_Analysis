function [balanceParams, h] = calcBalanceFunc(band1spatial,band2spatial,speckVar,balanceParams)

noise = balanceParams.noise;
meanNoiseLevel = balanceParams.meanNoiseLevel;
funcPower = balanceParams.power;
figVisEnable = balanceParams.figVisEnable;

if balanceParams.autoROI
    [balanceMask, noiseMask, ~] = detectTissue(band1spatial+band2spatial);       
    ROI(1) = find(sum(balanceMask,2) > 10,1,'first');
    ROI(2) = find(sum(balanceMask,2) > 10,1,'last');
    ROI(3) = 1;
    ROI(4) = size(band1spatial,2);

    balanceParams.ROI = ROI;
else
    if isempty(balanceParams.ROI)
        figh = figure('name','Mark a region according which to balance');
        set(figh, 'Visible', figVisEnable)
        imagesc(log((band1spatial+band2spatial)/2));
        colormap gray;
        rect = round(getrect);
        balanceParams.ROI(1) = rect(2); % top
        balanceParams.ROI(2) = rect(2)+rect(4)-1; % bottom
        balanceParams.ROI(3) = rect(1); % left
        balanceParams.ROI(4) = rect(1)+rect(3)-1; % right
        
    end
    
    ROI = balanceParams.ROI;    
    balanceMask = zeros(size(band1spatial));
    balanceMask(ROI(1):ROI(2),ROI(3):ROI(4)) = 1;
    
    if isempty(noise) || isempty(meanNoiseLevel) || any(noise == 0) || any(meanNoiseLevel == 0),
        figh = figure('name','Mark a region of noise');
        set(figh, 'Visible', figVisEnable)
        imagesc(log(abs(band1spatial+band2spatial)));
        colormap gray;
        rect = round(getrect);
        c = rect(1); r = rect(2); w = rect(3); h = rect(4);
        noiseMask = zeros(size(band1spatial));
        noiseMask(r:r+h,c:c+w) = 1;
    end
end

if balanceParams.exclude_vessels && ~isempty(speckVar)
    speckVar = speckVar - min(speckVar(:));
    speckVar = speckVar/max(speckVar(:));
    vesselMask = speckVar > balanceParams.exclude_vessels_thr;
    balanceMask(vesselMask == 1) = 0;
end

bandSpatial(:,:,1) = band1spatial;
bandSpatial(:,:,2) = band2spatial;
nRows = ROI(2)-ROI(1)+1;
nCols = ROI(4)-ROI(3)+1;

if isempty(noise) || isempty(meanNoiseLevel) || any(noise == 0) || any(meanNoiseLevel == 0),
    for ind = 1:2
        band = bandSpatial(:,:,ind);
        noiseROI = band;
        noiseROI = noiseROI(noiseMask == 1);
        meanNoiseLevel(ind) = mean(noiseROI(:));
        noise(ind) = std(noiseROI(:));
    end
end
for ind = 1:2
    band = bandSpatial(:,:,ind);
    band = band - meanNoiseLevel(ind);
    band(band<0) = min(band(band(:)>0));
    band = wiener2(band,[5 5]);
    band = band.*balanceMask;
    bandSpatial(:,:,ind) = band;
end

meanSig = zeros(nRows,2);
gain = zeros(nRows,2);
x = [1:nRows]';
for rowInd = 1:nRows
    b1 =  bandSpatial(ROI(1)+rowInd-1,:,1);
    b2 =  bandSpatial(ROI(1)+rowInd-1,:,2);
    
    b2(b1 < noise(1)) = [];
    b1(b1 < noise(1)) = [];
    b1(b2 < noise(2)) = [];
    b2(b2 < noise(2)) = [];
    if (length(b1)<10) || (length(b2)<10)        
        x(rowInd) = 0;
    else
        meanSig(rowInd,1) = mean(b1);
        meanSig(rowInd,2) = mean(b2);
        meanb1b2 = (mean(b1) + mean(b2))/2;
        gain(rowInd,1) = meanSig(rowInd,1)/meanb1b2;
        gain(rowInd,2) = meanSig(rowInd,2)/meanb1b2;
    end
end
meanSig(x==0,:) = [];
gain(x==0,:) = [];
x(x==0) = [];

h(1) = figure;
set(h(1), 'Visible', figVisEnable);
plot(x,meanSig(:,1),'.-r'); hold on; plot(x,meanSig(:,2),'.-b');

h(2) = figure;
set(h(2), 'Visible', figVisEnable)
hold on;
plot(x,gain(:,1),'b:');
plot(x,gain(:,2),'r:');

P1 = polyfit(x,gain(:,1),funcPower);
P2 = polyfit(x,gain(:,2),funcPower);

x = [1:nRows]';
fitGainFunc = zeros(length(x),2);
for ind = 0:funcPower
    fitGainFunc(:,1) =  fitGainFunc(:,1) + P1(funcPower-ind+1)*x.^ind;
    fitGainFunc(:,2) =  fitGainFunc(:,2) + P2(funcPower-ind+1)*x.^ind;
end
plot(fitGainFunc(:,1),'b')
plot(fitGainFunc(:,2),'r')

h(3) = figure;
set(h(3), 'Visible', figVisEnable)
diff_image = bandSpatial(:,:,1) - bandSpatial(:,:,2);
subplot(2,1,1); imagesc(diff_image); caxis([-1 1]); title('Before balance')

diff_image_temp = bandSpatial(ROI(1):ROI(2),:,1)./repmat(fitGainFunc(:,1),[1 size(bandSpatial,2)]) - bandSpatial(ROI(1):ROI(2),:,2)./repmat(fitGainFunc(:,2),[1 size(bandSpatial,2)]);
diff_image(ROI(1):ROI(2),:) = diff_image_temp;
subplot(2,1,2); imagesc(diff_image); caxis([-1 1]); title('After balance'); 

balanceParams.noise = noise;
balanceParams.meanNoiseLevel = meanNoiseLevel;
balanceParams.func = fitGainFunc;

h(4) = figure;
set(h(4), 'Visible', figVisEnable)
imagesc(balanceMask)
