clc ;clear; close all
tic
run spectralParamsV3_2D_Ascan

[outputFolderResults,outputFolderSignal,outputFolderSpeckVar] =  createFolders(outputFolder);

%% Run over files
for fileInd = fileStartInd:1:length(filesToRun)
    fileName = filesToRun(fileInd).name;
    fileAndPath = [inputFolder fileName];
    scanLabel = getScanLabel(fileName,scanMode,scanLabelVisEnable);
    xmlHeader = xml_read([fileAndPath '/Header.xml']);
    [pixX, pixZ, pixY, ascanAve, bscanAve] = getParamsFromXml(xmlHeader,scanMode);
    outputFrameNum = getFrameNum(xmlHeader,frames2Avg);
        
    Buff = double(createBufferTemplate(viewRange, xmlHeader.Image.SizePixel.SizeX, pixX, pixZ, trueToScale, reSizeMethod, outputFrameNum));
    [signalBuff,bandBuff,rawSpeckVarBuff,diffBuff,speckVarBuff,diffNormBuff] = deal(Buff);        
    clear Buff
    
    for frameInd = [round(outputFrameNum/2):outputFrameNum 1:round(outputFrameNum/2)-1]
        %% Get data from files
        [interf, avgLogBscan, linBscan, ~, apodization,timeStamp] = ...
            getDataFromFiles(scanMode,fileAndPath,frameInd,outputFrameNum,xmlHeader,chirp_vect,dispersionParams,filt,frames2Avg,bscanAve,additionalFrameAvgOverlap);
        %     figure; imagesc(avgLogBscan); colormap gray
        scanName = [scanLabel ' ' num2str(frameInd) ' ' datestr(datenum(timeStamp),30)];
        apodization = squeeze(mean(apodization,2));
        
        %% Find dispersion coefficients
        %        load([outputFolderResults 'balance.mat']);     % Load balance function for improving the dispersion algorithm
        if isempty(dispComp.a2) || isempty(dispComp.b2)
            [a2, b2] = findDispersionConstants1_6(kVect, apodization, interf, ascanAve, [outputFolder '/dispersion/'], dispersionParams,spectParams,balanceFunc);
            dispComp.a2 = a2; dispComp.b2 = b2;
            dispersionParams.a2 = a2; dispersionParams.b2 = b2;
            [interf, avgLogBscan, linBscan, ~, apodization,timeStamp] = ...
            getDataFromFiles(scanMode,fileAndPath,frameInd,outputFrameNum,xmlHeader,chirp_vect,dispersionParams,filt,frames2Avg,bscanAve,additionalFrameAvgOverlap);
        end
        
        %% Spectral analysis
        if saveAlgoData && strcmp(scanMode,'Bscan')
            saveAlgoDataPath = [outputFolderResults scanName '_Algo_'];
        else
            saveAlgoDataPath = [];
        end
        [BscanCpx,BscanCpxNorm, band1spatial, band2spatial, compoundImg, diffImg, balanceFunc, h] =...
            spectralAnalysis4(kVect, apodization, interf, ascanAve, dispComp, spectParams, balanceEnable, balanceFunc, size(interf,3), saveAlgoDataPath);
        save([outputFolderResults balanceFuncName],'balanceFunc')
        if ~balanceAsFirst,
            balanceFunc.func = []; %balanceFunc.ROI = [];
        end
%         [~,~, bandBuff] =...
%             spectralAnalysis4STFT(kVect, apodization, interf, ascanAve, dispComp, spectParams, balanceEnable, balanceFunc, size(interf,3), saveAlgoDataPath);
%         bandBuff = bandBuff(viewRange,:,:);
        
        if savePng, saveAllFigs(h,[outputFolderResults datestr(datenum(timeStamp),30) '_' scanName '_spectralSaves' '_' num2str(frameInd) '_']); end
        
        if strcmp(OCTSystem,'Telesto')
            % In order to see particles of larger WL in Telesto with better  contrast (green color)
            diffImg = -diffImg;
        end
        
        if size(linBscan,3) >= stdLim
            [speckVarNorm] = speckleVariance(linBscan,normThr,stdSize);
        else
            speckVarNorm = [];
        end
        
        [linBscanResize,diffImg,compoundImg,~,speckVarNorm] = cropScaleOutput(viewRange,trueToScale,reSizeMethod,pixX,pixZ,linBscan,diffImg,compoundImg,speckVarNorm);
        
        % log signal
        if savePng, plotAndSaveImg(log(mean(linBscanResize,3)), figVisEnable, [scanName ' log Bscan'], 'gray', [], [outputFolderSignal datestr(datenum(timeStamp),30) '_' scanName '_Bscan_log_scale' num2str(frameInd)], 'png'); end
        signalBuff(:,:,frameInd) = uint8(scale0To255(log(mean(linBscanResize,3))));
%         signalBuff = mean(linBscan(viewRange,:,:),3);
       
        % structure
        if savePng, plotAndSaveHSV(scaleAround0Between01(diffImg,diffScale), ones(size(diffImg)), 3*scale0To255(log(compoundImg)), figVisEnable, [scanName ' spectral analysis, structure'], [outputFolderResults '/struct/' datestr(datenum(timeStamp),30) '_' scanName '_structure' num2str(frameInd)],'png');        end
        diffBuff(:,:,frameInd) = uint8(255*scaleAround0Between01(diffImg,diffScale));
        
        if ~isempty(speckVarNorm)
            % speckle varaince
            rawSpeckVarBuff(:,:,frameInd) = uint8(scale0To255(speckVarNorm));
            if savePng, plotAndSaveImg(speckVarNorm, figVisEnable, [scanName ' normalized speckle variance'], 'jet', [0 0.7], [outputFolderSpeckVar datestr(datenum(timeStamp),30) '_' scanName '_normalized_speckleVar'], 'png');             end
            
            speckVarNormScaled = speckVarNorm - thrSpeckVar;
            speckVarNormScaled(speckVarNormScaled < 0) = 0;
            speckVarNormScaled(speckVarNormScaled > maxSpeckVar) = maxSpeckVar;
            speckVarNormScaled = scale0To255(speckVarNormScaled);
            % angio gated
            if savePng, plotAndSaveHSV(scaleAround0Between01(diffImg,diffScale), ones(size(diffImg)), speckVarNormScaled, figVisEnable, [scanName ' spectral analysis, angio gated'], [outputFolderResults '/angio/' datestr(datenum(timeStamp),30) '_' scanName '_angio_linear' num2str(frameInd)],'png');            end
            speckVarBuff(:,:,frameInd) = uint8(speckVarNormScaled);
            % combined
            plotAndSaveHSV(scaleAround0Between01(diffImg,diffScale), speckVarNormScaled/255, scale0To255(log(mean(abs(linBscanResize),3))), figVisEnable, [scanName ' spectral analysis, combined angio gated'], [outputFolderResults '/combined/' datestr(datenum(timeStamp),30) '_' scanName '_combined' num2str(frameInd)],'png');
        end
        
        thr = 0.1;
        norm = compoundImg;
        norm(norm<thr) = thr;
        tempDiffNorm = (scaleAround0Between01(diffImg,diffScale)-1/2)./norm;
        if savePng, plotAndSaveHSV(scaleAround0Between01(tempDiffNorm,diffNormScale), ones(size(diffImg)), 3*scale0To255(log(compoundImg)), figVisEnable, [scanName ' spectral analysis, diff normalized, structure'], [outputFolderResults '/structnorm/' datestr(datenum(timeStamp),30) '_' scanName '_structure_norm' num2str(frameInd)],'png');        end
        % plotAndSaveImg(scaleAround0Between01(tempDiffNorm,diffNormScale), figVisEnable, [scanName ' spectral analysis, diff normalized'], 'jet', [0.2 0.8], [outputFolderResults '/' scanName '_diff_norm' num2str(frameInd)], 'png')
        diffNormBuff(:,:,frameInd) = uint8(255*scaleAround0Between01(tempDiffNorm,diffNormScale));
        
        if (~isempty(speckVarNorm)) && savePng
            plotAndSaveHSV(scaleAround0Between01(tempDiffNorm,diffNormScale), speckVarNormScaled/255, scale0To255(log(mean(abs(linBscanResize),3))), figVisEnable, [scanName ' spectral analysis, diff normalized, combined'], [outputFolderResults '/combined_norm/' datestr(datenum(timeStamp),30) '_' scanName '_combined_norm' num2str(frameInd)],'png');
            plotAndSaveHSV(scaleAround0Between01(tempDiffNorm,diffNormScale), ones(size(diffImg)), speckVarNormScaled, figVisEnable, [scanName ' spectral analysis, diff normalized, angio'], [outputFolderResults '/angio_norm/' scanName '_angio_norm' num2str(frameInd)],'png');
        end
        close all
    end % end of frameInd
    if saveBuffers
        save([outputFolderResults datestr(datenum(timeStamp),30) '_' scanName '_Buffer'],'signalBuff','diffBuff','speckVarBuff','diffNormBuff','xmlHeader','rawSpeckVarBuff');
    end
end % end of fileInd
toc
if exist('tempWorkSpace.mat', 'file')==2
    delete('tempWorkSpace')
end