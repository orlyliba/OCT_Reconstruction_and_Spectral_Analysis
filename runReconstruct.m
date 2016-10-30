clc ;clear; close all
tic
run reconstructParams_2D

%% Run over files
for fileInd = fileStartInd:1:length(filesToRun)
    fileName = filesToRun(fileInd).name;
    fileAndPath = [inputFolder fileName];
    scanLabel = getScanLabel(fileName,scanMode,scanLabelVisEnable);
    xmlHeader = xml_read([fileAndPath '/Header.xml']);
    [pixX, pixZ, pixY, ascanAve, bscanAve] = getParamsFromXml(xmlHeader,scanMode);
    outputFrameNum = getFrameNum(xmlHeader,frames2Avg);
        
    Buff = double(createBufferTemplate(viewRange, xmlHeader.Image.SizePixel.SizeX, pixX, pixZ, trueToScale, reSizeMethod, outputFrameNum));
    [signalBuff] = deal(Buff);        
    clear Buff
    
    for frameInd = [round(outputFrameNum/2):outputFrameNum 1:round(outputFrameNum/2)-1]
        %% Get data from files
        [interf, avgLogBscan, linBscan, ~, apodization,timeStamp] = ...
            getDataFromFiles(scanMode,fileAndPath,frameInd,outputFrameNum,xmlHeader,chirp_vect,dispersionParams,filt,frames2Avg,bscanAve,additionalFrameAvgOverlap);
        %     figure; imagesc(avgLogBscan); colormap gray
        scanName = [scanLabel ' ' num2str(frameInd) ' ' datestr(datenum(timeStamp),30)];
        apodization = squeeze(mean(apodization,2));
        
        %% Find dispersion coefficients        
        if isempty(dispComp.a2) || isempty(dispComp.b2)
            [a2, b2] = findDispersionConstants1_6(kVect, apodization, interf, ascanAve, [outputFolder '/dispersion/'], dispersionParams,spectParams,balanceFunc);
            dispComp.a2 = a2; dispComp.b2 = b2;
            dispersionParams.a2 = a2; dispersionParams.b2 = b2;
            [interf, avgLogBscan, linBscan, ~, apodization,timeStamp] = ...
            getDataFromFiles(scanMode,fileAndPath,frameInd,outputFrameNum,xmlHeader,chirp_vect,dispersionParams,filt,frames2Avg,bscanAve,additionalFrameAvgOverlap);
        end
                        
        [linBscanResize,~,~,~,~] = cropScaleOutput(viewRange,trueToScale,reSizeMethod,pixX,pixZ,linBscan,[],[],[]);
        
        % log signal
        if savePng, plotAndSaveImg(log(mean(linBscanResize,3)), figVisEnable, [scanName ' log Bscan'], 'gray', [], [outputFolderSignal datestr(datenum(timeStamp),30) '_' scanName '_Bscan_log_scale' num2str(frameInd)], 'png'); end
        signalBuff(:,:,frameInd) = uint8(scale0To255(log(mean(linBscanResize,3))));
        % signalBuff(:,:,frameInd) = mean(linBscanResize,3); if linear signal is needed use this (but larger files will be saved)
        
        if saveTiff           
            if (frameInd==1), WriteMode = 'overwrite'; else WriteMode = 'append'; end            
             outputFileName = [outputFolderSignal datestr(datenum(timeStamp),30) '_' scanName '.tif'];
             imwrite(uint8(scale0To255(log(mean(linBscanResize,3)))), outputFileName, 'WriteMode', WriteMode,'Compression','none');
        end
       
        close all
    end % end of frameInd
    if saveBuffers
        save([outputFolderSignal datestr(datenum(timeStamp),30) '_' scanName '_Buffer'],'signalBuff','xmlHeader');
    end    
end % end of fileInd
toc