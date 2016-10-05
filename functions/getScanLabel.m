function scanLabel = getScanLabel(fileName,mode,scanLabelVisEnable)
switch mode
    case 'speckVar'
        scanLabel = fileName(1:end-12);
    case 'Bscan'
        scanLabel = fileName(1:end-7);
    case '3D'
        scanLabel = fileName(1:end-7);
end
scanLabel(strfind(scanLabel,'_')) = ' ';
scanLabel(strfind(scanLabel,'(')) = ''; 
scanLabel(strfind(scanLabel,')')) = '';
if strcmp(scanLabelVisEnable,'on')
    disp(scanLabel)
end