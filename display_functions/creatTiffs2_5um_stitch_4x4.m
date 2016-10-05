close all; clear; clc;
pathName = '/home/adlz/Orly/3D for high injection/15-02-24 lymph GNRs large FOV/';
fileName = dir([pathName '*.mat']);

pixX = 2; % because of true to scale
pixZ = 2;
pixY = 5; %
resizeMethod = 'linear';
pixOut = 5;

createCombined = 0;
createCombinedNorm = 0;
createAngio = 1;
createAngioNorm = 1;
createLogsignal = 0;
createStructure = 0;

ext = 1;

for FOVInd  = 33, %FOVInd = 1:16:length(fileName)%1:16:length(fileName)
    
    for rowInd = 4:-1:1
        [diffBuffArr,diffNormBuffArr,signalBuffArr,speckVarBuffArr] = deal([]);
        for colInd = 1:4
            disp(fileName((FOVInd-1) + (rowInd-1)*4 + colInd).name)
            load([pathName fileName((FOVInd-1) + (rowInd-1)*4 + colInd).name]);
            
            nz = size(signalBuff,1);
            nx = size(signalBuff,2);
            ny = size(signalBuff,3);
            
            iniScalex = 1:pixX:pixX*nx;
            iniScalez = 1:pixZ:pixZ*nz;
            iniScaley = 1:pixY:pixY*ny;
            
            resizeScalex = 1:pixOut:pixX*nx;
            resizeScalez = 1:pixOut:pixZ*nz;
            resizeScaley = 1:pixOut:pixY*ny;
            
            [Xq,Yq,Zq] = meshgrid(resizeScalex,resizeScalez,resizeScaley);
            diffBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffBuff),Xq,Yq,Zq,resizeMethod)*ext;
            diffNormBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffNormBuff),Xq,Yq,Zq,resizeMethod);
            signalBuff = interp3(iniScalex,iniScalez,iniScaley,double(signalBuff),Xq,Yq,Zq,resizeMethod);
            speckVarBuff = interp3(iniScalex,iniScalez,iniScaley,double(speckVarBuff),Xq,Yq,Zq,resizeMethod);
            
            diffBuffArr = [diffBuffArr permute(diffBuff,[1 3 2])];
            diffNormBuffArr = [diffNormBuffArr permute(diffNormBuff,[1 3 2])];
            signalBuffArr = [signalBuffArr permute(signalBuff,[1 3 2])];
            speckVarBuffArr = [speckVarBuffArr permute(speckVarBuff,[1 3 2])];
        end % colInd        
        
        % write rows        
        if rowInd == 4
            k = 1;
            if createCombined
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_combined.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffBuffArr(:,:,k)/255,speckVarBuffArr(:,:,k)/255,signalBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName,'Compression','none');
            end
            if createCombinedNorm
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_combinedNorm.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffNormBuffArr(:,:,k)/255,speckVarBuffArr(:,:,k)/255,signalBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName,'Compression','none');
            end
            if createAngio
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_angio.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),speckVarBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName,'Compression','none');
            end
            if createAngioNorm
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_angioNorm.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffNormBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),speckVarBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName,'Compression','none');
            end
            if createLogsignal
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_logSignal.tif'];
                imwrite(uint8(signalBuffArr(:,:,k)), outputFileName,'Compression','none');
            end
            if createStructure
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_structure.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),signalBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName,'Compression','none');
            end
        else
            k = 0;
        end
        
        
        for k = (k+1):length(resizeScaley)
            if createCombined
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_combined.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffBuffArr(:,:,k)/255,speckVarBuffArr(:,:,k)/255,signalBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
            end
            if createCombinedNorm
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_combinedNorm.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffNormBuffArr(:,:,k)/255,speckVarBuffArr(:,:,k)/255,signalBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
            end
            if createAngio
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_angio.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),speckVarBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
            end
            if createAngioNorm
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_angioNorm.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffNormBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),speckVarBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
            end
            if createLogsignal
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_logSignal.tif'];
                imwrite(uint8(signalBuffArr(:,:,k)), outputFileName, 'WriteMode', 'append','Compression','none');
            end
            if createStructure
                outputFileName = [pathName fileName(FOVInd).name(1:end-11) '_structure.tif'];
                RGB = uint8(hsv2rgb(cat(3,diffBuffArr(:,:,k)/255,ones(size(speckVarBuffArr(:,:,k))),signalBuffArr(:,:,k))));
                imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
            end
        end
    end %rowInd
end % FOVInd
