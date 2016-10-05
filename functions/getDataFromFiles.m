function [interf, avgLogBscan, linBscan, BscanCpx, apodization,timeStamp] = ...
    getDataFromFiles(mode,fileAndPath,frameInd,outputFrameNum,xmlHeader,chirp_vect,dispersionParams,filt,framesToAvg,bscanAve,additionalFrameAvgOverlap)

if outputFrameNum == 1
    frames2process = []; % process all frames
else
    switch mode
        case {'speckVar','3D'}            
            if frameInd == 1
                frames2process = 1 + ((frameInd-1)*framesToAvg)*bscanAve : (frameInd*framesToAvg + additionalFrameAvgOverlap)*bscanAve;
            elseif frameInd == outputFrameNum
                frames2process = 1 + ((frameInd-1)*framesToAvg - additionalFrameAvgOverlap)*bscanAve : frameInd*framesToAvg*bscanAve;
            else
                frames2process = 1 + ((frameInd-1)*framesToAvg - additionalFrameAvgOverlap)*bscanAve : ...
                    (frameInd*framesToAvg + additionalFrameAvgOverlap)*bscanAve;
            end
        case 'Bscan'
            frames2process = 1 + (frameInd-1)*framesToAvg : frameInd*framesToAvg;
    end
end

switch mode
    case {'speckVar','3D'}
        [~, ~, interf, avgLogBscan, linBscan, BscanCpx, apodization,timeStamp] = getBScans_V4_10_SpeckVarMode(fileAndPath,xmlHeader,chirp_vect,dispersionParams,frames2process,filt);
    case 'Bscan'
        [~, ~, interf, avgLogBscan, linBscan, BscanCpx, apodization,timeStamp] = getBScans_V4_10(fileAndPath,xmlHeader,chirp_vect,dispersionParams,frames2process,filt);
end