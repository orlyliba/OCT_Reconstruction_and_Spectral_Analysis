function createPngBscanFunction(pathName,create,colorMapOption,LymphThr,diffScaling,relevantRows,outputSuffix)
WriteMode = 'overwrite';

fileName = dir([pathName '*.mat']);
for scanInd  = 1:length(fileName)
    disp(fileName(scanInd).name)
    load([pathName fileName(scanInd).name]);
    
    relevantRows(relevantRows > size(signalBuff,1)) = [];
    signalBuff = double(signalBuff(relevantRows,:,:));
    diffNormBuff = double(diffNormBuff(relevantRows,:,:));
    speckVarBuff = double(speckVarBuff(relevantRows,:,:));
    diffBuff = double(diffBuff(relevantRows,:,:));
    rawSpeckVarBuff = double(rawSpeckVarBuff(relevantRows,:,:));
    
    lymphBuff = detectLymph(signalBuff,LymphThr);    
    
    if create.Combined
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_combined_' outputSuffix '.tif'];
        RGB = uint8(hsv2colormap(diffBuff/255,speckVarBuff/255,signalBuff,colorMapOption));
        imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
    if create.CombinedNorm
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_combinedNorm_' outputSuffix '.tif'];
        RGB = uint8(hsv2colormap(diffNormBuff/255,speckVarBuff/255,signalBuff,colorMapOption));
        imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
    if create.Angio
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_angio_' outputSuffix '.tif'];
        RGB = uint8(hsv2colormap(diffBuff/255,ones(size(speckVarBuff)),speckVarBuff,colorMapOption));
        imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
    if create.AngioNorm
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_angioNorm_' outputSuffix '.tif'];
        RGB = uint8(hsv2colormap(diffNormBuff/255,ones(size(speckVarBuff)),speckVarBuff,colorMapOption));
        imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
    if create.Logsignal
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_logSignal_' outputSuffix '.tif'];
        imwrite(uint8(signalBuff), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
    if create.Structure
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_structure_' outputSuffix '.tif'];
        RGB = uint8(hsv2colormap(diffBuff/255,ones(size(speckVarBuff)),signalBuff,colorMapOption));
        imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
    if create.Lymph
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_lymph_' outputSuffix '.tif'];
        imwrite(uint8(lymphBuff), outputFileName,'WriteMode', WriteMode,'Compression','none');
    end
    if create.LymphCombined
        outputFileName = [pathName fileName(scanInd).name(1:end-11) '_lymph_combined_' outputSuffix '.tif'];
        RGB = uint8(cat(3,signalBuff+lymphBuff,signalBuff,signalBuff));
        imwrite(uint8(RGB), outputFileName,'WriteMode', WriteMode,'Compression','none');
    end
    if create.SpeckVarRaw
        outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_raw_speckle_var_' outputSuffix '.tif'];
        imwrite(uint8(rawSpeckVarBuff), outputFileName, 'WriteMode', WriteMode,'Compression','none');
    end
end




