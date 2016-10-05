pathName = '/home/adlz/Orly/3D for high injection/15-02-19 lymph GNRs/3D/';
fileName = dir([pathName '*.mat']);

pixX = 2; % because of true to scale
pixZ = 2;
pixY = 15; % 3 frames are used, 5 um apart, no overlap
resizeMethod = 'linear';
pixOut = 5;

createCombined = 0;
createCombinedNorm = 0;
createAngio = 0;
createAngioNorm = 0;
createLogsignal = 1;
createStructure = 0;


for ind = 1:2:length(fileName)
    load([pathName fileName(ind+1).name]);
    
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
    diffBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffBuff),Xq,Yq,Zq,resizeMethod);
    diffNormBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffNormBuff),Xq,Yq,Zq,resizeMethod);
    signalBuff = interp3(iniScalex,iniScalez,iniScaley,double(signalBuff),Xq,Yq,Zq,resizeMethod);
    speckVarBuff = interp3(iniScalex,iniScalez,iniScaley,double(speckVarBuff),Xq,Yq,Zq,resizeMethod);
    
    k = 1;
    if createCombined
        outputFileName = [pathName fileName(ind).name(1:end-11) '_combined_stitched.tif'];
        RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(speckVarBuff(:,k,:))/255,squeeze(signalBuff(:,k,:)))));
        imwrite(uint8(RGB), outputFileName,'Compression','none');
    end
    if createCombinedNorm
        outputFileName = [pathName fileName(ind).name(1:end-11) '_combinedNorm_stitched.tif'];
        RGB = uint8(hsv2rgb(cat(3,squeeze(diffNormBuff(:,k,:))/255,squeeze(speckVarBuff(:,k,:))/255,squeeze(signalBuff(:,k,:)))));
        imwrite(uint8(RGB), outputFileName,'Compression','none');
    end
    if createAngio
        outputFileName = [pathName fileName(ind).name(1:end-11) '_angio_stitched.tif'];
        RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(speckVarBuff(:,k,:)))));
        imwrite(uint8(RGB), outputFileName,'Compression','none');
    end
    if createAngioNorm
        outputFileName = [pathName fileName(ind).name(1:end-11) '_angioNorm_stitched.tif'];
        RGB = uint8(hsv2rgb(cat(3,squeeze(diffNormBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(speckVarBuff(:,k,:)))));
        imwrite(uint8(RGB), outputFileName,'Compression','none');
    end
    if createLogsignal
        outputFileName = [pathName fileName(ind).name(1:end-11) '_logSignal_stitched.tif'];
        imwrite(uint8(squeeze(signalBuff(:,k,:))), outputFileName,'Compression','none');
    end
    if createStructure
        outputFileName = [pathName fileName(ind).name(1:end-11) '_structure_stitched.tif'];
        RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(signalBuff(:,k,:)))));
        imwrite(uint8(RGB), outputFileName,'Compression','none');
    end
    
    
    for k = 2:length(resizeScalex)
        if createCombined
            outputFileName = [pathName fileName(ind).name(1:end-11) '_combined_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(speckVarBuff(:,k,:))/255,squeeze(signalBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createCombinedNorm
            outputFileName = [pathName fileName(ind).name(1:end-11) '_combinedNorm_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffNormBuff(:,k,:))/255,squeeze(speckVarBuff(:,k,:))/255,squeeze(signalBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createAngio
            outputFileName = [pathName fileName(ind).name(1:end-11) '_angio_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(speckVarBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createAngioNorm
            outputFileName = [pathName fileName(ind).name(1:end-11) '_angioNorm_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffNormBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(speckVarBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createLogsignal
            outputFileName = [pathName fileName(ind).name(1:end-11) '_logSignal_stitched.tif'];
            imwrite(uint8(squeeze(signalBuff(:,k,:))), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createStructure
            outputFileName = [pathName fileName(ind).name(1:end-11) '_structure_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(signalBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
    end
    
    load([pathName fileName(ind).name]);
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
    diffBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffBuff),Xq,Yq,Zq,resizeMethod);
    diffNormBuff = interp3(iniScalex,iniScalez,iniScaley,double(diffNormBuff),Xq,Yq,Zq,resizeMethod);
    signalBuff = interp3(iniScalex,iniScalez,iniScaley,double(signalBuff),Xq,Yq,Zq,resizeMethod);
    speckVarBuff = interp3(iniScalex,iniScalez,iniScaley,double(speckVarBuff),Xq,Yq,Zq,resizeMethod);
    
    for k = 1:length(resizeScalex)
        if createCombined
            outputFileName = [pathName fileName(ind).name(1:end-11) '_combined_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(speckVarBuff(:,k,:))/255,squeeze(signalBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createCombinedNorm
            outputFileName = [pathName fileName(ind).name(1:end-11) '_combinedNorm_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffNormBuff(:,k,:))/255,squeeze(speckVarBuff(:,k,:))/255,squeeze(signalBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createAngio
            outputFileName = [pathName fileName(ind).name(1:end-11) '_angio_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(speckVarBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createAngioNorm
            outputFileName = [pathName fileName(ind).name(1:end-11) '_angioNorm_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffNormBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(speckVarBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createLogsignal
            outputFileName = [pathName fileName(ind).name(1:end-11) '_logSignal_stitched.tif'];
            imwrite(uint8(squeeze(signalBuff(:,k,:))), outputFileName, 'WriteMode', 'append','Compression','none');
        end
        if createStructure
            outputFileName = [pathName fileName(ind).name(1:end-11) '_structure_stitched.tif'];
            RGB = uint8(hsv2rgb(cat(3,squeeze(diffBuff(:,k,:))/255,squeeze(ones(size(speckVarBuff(:,k,:)))),squeeze(signalBuff(:,k,:)))));
            imwrite(uint8(RGB), outputFileName, 'WriteMode', 'append','Compression','none');
        end
    end
    
end
