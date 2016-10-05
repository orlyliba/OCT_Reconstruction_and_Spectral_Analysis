function [pixX, pixZ, pixY, ascanAve, bscanAve] = getParamsFromXml(xmlHeader, mode)
pixX = xmlHeader.Image.PixelSpacing.SpacingX*1000;
pixZ = xmlHeader.Image.PixelSpacing.SpacingZ*1000;
switch mode
    case 'speckVar'
        bscanAve =  xmlHeader.Acquisition.SpeckleAveraging.SlowAxis;
        if  isfield(xmlHeader.Acquisition,'SpeckleAveraging') && isfield(xmlHeader.Acquisition.SpeckleAveraging,'FastAxis')
            ascanAve = xmlHeader.Acquisition.SpeckleAveraging.FastAxis;
        elseif isfield(xmlHeader.Acquisition,'IntensityAveraging') && isfield(xmlHeader.Acquisition.IntensityAveraging,'AScans')
            ascanAve = xmlHeader.Acquisition.IntensityAveraging.AScans;
        end        
        pixY = xmlHeader.Image.PixelSpacing.SpacingY*1000;
    case 'Bscan'        
        if isfield(xmlHeader.Image.SizePixel,'SizeY')
            bscanAve =  xmlHeader.Image.SizePixel.SizeY;
        else
            bscanAve = 1;
        end
        ascanAve = xmlHeader.Acquisition.IntensityAveraging.AScans;
        pixY = 0;
    case '3D'
        bscanAve = 1;
        ascanAve = xmlHeader.Acquisition.IntensityAveraging.AScans;
        pixY = xmlHeader.Image.PixelSpacing.SpacingY*1000;
end

