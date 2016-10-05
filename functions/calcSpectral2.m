function [BscanCpx,BscanCpxNorm, band1spatial, band2spatial, compoundImg, diffImg] =...
                calcSpectral2(k, apodization, interf, ascanAve, dispComp, params, frames2Avg)

nFrames = size(interf,3);
nAscans = size(interf,2);
FFTLength = length(k);
m = [0:FFTLength-1];

% Apodization
apodThr = mean(mean(apodization))/params.apodNormThr;

winHannBand1 = hann(params.sizeHannBand1);
winHannBand2 = hann(params.sizeHannBand2);
BandComp = sum(winHannBand2)/sum(winHannBand1);
indicesBand1 = params.start_band1 : params.start_band1+params.sizeHannBand1-1;
indicesBand2 = params.end_band2-params.sizeHannBand2+1 : params.end_band2;
frameHann1 = repmat(winHannBand1,[1 nAscans]);
frameHann2 = repmat(winHannBand2,[1 nAscans]);
avgFilt = ones(1,ascanAve)/(ascanAve);
[band1spatial,band2spatial] = deal(zeros(FFTLength/2,nAscans/ascanAve,nFrames));
BscanCpxNorm = zeros(FFTLength/2,nAscans,nFrames);
BscanCpx = zeros(FFTLength/2,nAscans,nFrames);
[diffImg, compoundImg] = deal(zeros(FFTLength/2,nAscans/ascanAve,floor(nFrames/frames2Avg)));

[K, M] = meshgrid(k,m(1:end/2));
TempFFTM = exp(1i.*M.* (2*pi/FFTLength*K + dispComp.b2*K.^2/FFTLength.^2));
Phase = exp(1i*(dispComp.a2*k.^2/FFTLength))';

Phase = repmat(Phase,[1 nAscans 1]);
for frameInd = 1:nFrames
    apodsmooth = conv(apodization(:,frameInd),window(@gausswin,20),'same')/sum(window(@gausswin,20));
    truncapod = apodsmooth;
    truncapod(truncapod<apodThr) = apodThr; 
    interfFrame = interf(:,:,frameInd);
    interfFrame = interfFrame.*Phase;
    BscanCpx(:,:,frameInd) = TempFFTM*interfFrame;
    interfFrame = interfFrame./repmat(truncapod,[1 nAscans]);
    band1 = interfFrame(indicesBand1,:).*frameHann1*BandComp;
    band2 = interfFrame(indicesBand2,:).*frameHann2;
    BscanCpxNorm(:,:,frameInd) = TempFFTM*interfFrame;
    temp = filter2(avgFilt,abs(TempFFTM(:,indicesBand1)*band1));
    band1spatial(:,:,frameInd) = temp(:,max(1,floor((ascanAve)/2)):ascanAve:end,:);
    temp = filter2(avgFilt,abs(TempFFTM(:,indicesBand2)*band2));
    band2spatial(:,:,frameInd) = temp(:,max(1,floor((ascanAve)/2)):ascanAve:end,:);
end

for ind = 1:floor(nFrames/frames2Avg)
    band1Temp = mean(band1spatial(:,:,1+frames2Avg*(ind-1):frames2Avg*ind),3);
    band2Temp = mean(band2spatial(:,:,1+frames2Avg*(ind-1):frames2Avg*ind),3);
    
    band1Temp = medfilt2(band1Temp,[4 4],'symmetric');
    band2Temp = medfilt2(band2Temp,[4 4],'symmetric');
    
    diffImg(:,:,ind) = params.GainB1*band1Temp - band2Temp; % longWL-shortWL
    compoundImg(:,:,ind) = params.GainB1*band1Temp + band2Temp;
end


