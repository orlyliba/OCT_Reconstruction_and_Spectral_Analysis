function [BscanCpx,BscanCpxNorm, band1spatial, band2spatial, compoundImg, diffImg, balanceFunc, h] =...
    spectralAnalysis4(k, apodization, interf, ascanAve, dispComp, params, balanceEnable, balanceFunc, frames2Avg, saveAlgoDataPath)

nFrames = size(interf,3);
nAscans = size(interf,2);
FFTLength = length(k);

[BscanCpx,BscanCpxNorm, band1spatial, band2spatial, ~, ~] = calcSpectral4(k, apodization, interf, ascanAve, dispComp, params, frames2Avg, saveAlgoDataPath);

if params.view
    figure; imagesc(log(mean(abs(BscanCpxNorm),3))); colormap gray
    figure; imagesc(mean(abs(band1spatial),3)-mean(abs(band2spatial),3)); caxis([-1 1]);
end

[band1spatial,band2spatial,balanceFunc, h] = balanceBands(balanceEnable,band1spatial,band2spatial,balanceFunc);

[diffImg, compoundImg] = deal(zeros(FFTLength/2,nAscans/ascanAve,floor(nFrames/frames2Avg)));
for ind = 1:floor(nFrames/frames2Avg)
    band1Temp = mean(band1spatial(:,:,1+frames2Avg*(ind-1):frames2Avg*ind),3);
    band2Temp = mean(band2spatial(:,:,1+frames2Avg*(ind-1):frames2Avg*ind),3);
    
    if params.medFiltBandsEnable
        band1Temp = medfilt2(band1Temp,[params.medFiltSize params.medFiltSize],'symmetric');
        band2Temp = medfilt2(band2Temp,[params.medFiltSize params.medFiltSize],'symmetric');
    end
    
    diffImg(:,:,ind) = params.GainB1*band1Temp - band2Temp; % longWL-shortWL

    compoundImg(:,:,ind) = params.GainB1*band1Temp + band2Temp;
end
% band1 = high WL (red) , band2 = low WL (blue)

%%
if ~isempty(saveAlgoDataPath)    
    band1AfterBalance  = mean(band1Temp,3);
    band2AfterBalance  = mean(band2Temp,3); 
    save([saveAlgoDataPath 'after_balance'],'band1AfterBalance','band2AfterBalance')
end

