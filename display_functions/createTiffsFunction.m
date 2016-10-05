function createTiffsFunction(pathName,create,FOVRows,FOVCols,colorMapOption,pixX,pixZ,pixY,pixOut,LymphThr,diffScaling,relevantRows,outputSuffix)
% for FOVs written from left top to right bottom
fileName = dir([pathName '*.mat']);
resizeMethod = 'linear';

for FOVInd  = 1:FOVCols*FOVRows:length(fileName)
    for rowInd = FOVRows:-1:1
        [diffBuffArr,diffNormBuffArr,signalBuffArr,speckVarBuffArr,rawSpeckVarBuffArr] = deal([]);
        for colInd = 1:FOVCols
            disp(fileName((FOVInd-1) + (rowInd-1)*FOVCols + colInd).name)
            load([pathName fileName((FOVInd-1) + (rowInd-1)*FOVCols + colInd).name]);
            
            nz = size(signalBuff,1);
            nx = size(signalBuff,2);
            ny = size(signalBuff,3);
            
            relevantRows(relevantRows > nz) = [];
            signalBuff = signalBuff(relevantRows,:,:);
            diffNormBuff = diffNormBuff(relevantRows,:,:);
            speckVarBuff = speckVarBuff(relevantRows,:,:);
            diffBuff = diffBuff(relevantRows,:,:);
            rawSpeckVarBuff = rawSpeckVarBuff(relevantRows,:,:);
            nz = size(signalBuff,1);
            
            iniScalex = 1:pixX:pixX*nx;
            iniScalez = 1:pixZ:pixZ*nz;
            iniScaley = 1:pixY:pixY*ny;
            
            resizeScalex = 1:pixOut:pixX*nx;
            resizeScalez = 1:pixOut:pixZ*nz;
            resizeScaley = 1:pixOut:pixY*ny;
            
            [Xq,Yq,Zq] = meshgrid(resizeScalex,resizeScalez,resizeScaley);
            diffBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffBuff),Xq,Yq,Zq,resizeMethod);
            diffNormBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffNormBuff),Xq,Yq,Zq,resizeMethod);
            signalBuff = interp3(iniScalex,iniScalez,iniScaley,double(signalBuff),Xq,Yq,Zq,resizeMethod);
            speckVarBuff = interp3(iniScalex,iniScalez,iniScaley,double(speckVarBuff),Xq,Yq,Zq,resizeMethod);
            
            if create.SpeckVarRaw
                rawSpeckVarBuff = interp3(iniScalex,iniScalez,iniScaley,double(rawSpeckVarBuff),Xq,Yq,Zq,resizeMethod);
                rawSpeckVarBuffArr = [rawSpeckVarBuffArr permute(rawSpeckVarBuff,[1 3 2])];
            end
            
            diffBuffArr = [diffBuffArr permute(diffBuff,[1 3 2])];
            diffNormBuffArr = [diffNormBuffArr permute(diffNormBuff,[1 3 2])];
            signalBuffArr = [signalBuffArr permute(signalBuff,[1 3 2])];
            speckVarBuffArr = [speckVarBuffArr permute(speckVarBuff,[1 3 2])];
            
        end % colInd
        
        if create.LymphCombined || create.Lymph
            lymphBuffArr = detectLymph(signalBuffArr,LymphThr);
        end
        
        % write rows
        for k = 1:length(resizeScaley)
            if (k==1 && rowInd == FOVRows)
                WriteMode = 'overwrite';
            else
                WriteMode = 'append';
            end
            if create.Combined
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_combined_' outputSuffix '.tif'];
                RGB = uint8(hsv2colormap(diffBuffArr(:,:,k)/255,speckVarBuffArr(:,:,k)/255,signalBuffArr(:,:,k),colorMapOption));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
            if create.CombinedNorm
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_combinedNorm_' outputSuffix '.tif'];
                RGB = uint8(hsv2colormap(diffNormBuffArr(:,:,k)/255,speckVarBuffArr(:,:,k)/255,signalBuffArr(:,:,k),colorMapOption));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
            if create.Angio
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_angio_' outputSuffix '.tif'];
                RGB = uint8(hsv2colormap(diffBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),speckVarBuffArr(:,:,k),colorMapOption));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
            if create.AngioNorm
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_angioNorm_' outputSuffix '.tif'];
                RGB = uint8(hsv2colormap(diffNormBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),speckVarBuffArr(:,:,k),colorMapOption));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
            if create.Logsignal
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_logSignal_' outputSuffix '.tif'];
                imwrite(uint8(signalBuffArr(:,:,k)), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
            if create.Structure
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_structure_' outputSuffix '.tif'];
                RGB = uint8(hsv2colormap(diffBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),signalBuffArr(:,:,k),colorMapOption));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
            if create.Lymph
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_lymph_' outputSuffix '.tif'];
                imwrite(uint8(lymphBuffArr(:,:,k)), outputFileName,'WriteMode', WriteMode,'Compression','none');
            end
            if create.LymphCombined
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_lymph_combined_' outputSuffix '.tif'];
                RGB = uint8(cat(3,signalBuffArr(:,:,k)+lymphBuffArr(:,:,k),signalBuffArr(:,:,k),signalBuffArr(:,:,k)));
                imwrite(uint8(RGB), outputFileName,'WriteMode', WriteMode,'Compression','none');
            end
            if create.SpeckVarRaw
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_raw_speckle_var_' outputSuffix '.tif'];
                imwrite(uint8(rawSpeckVarBuffArr(:,:,k)), outputFileName, 'WriteMode', WriteMode,'Compression','none');
            end
        end
    end %rowInd
end % FOVInd
