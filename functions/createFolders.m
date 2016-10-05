function [outputFolderResults,outputFolderSignal,outputFolderSpeckVar] =  createFolders(outputFolder)

outputFolderResults = [outputFolder 'spectral/'];
if ~isdir(outputFolderResults)
    mkdir(outputFolderResults)
end
if ~isdir([outputFolderResults '/angio'])
    mkdir([outputFolderResults '/angio'])
end
if ~isdir([outputFolderResults '/combined'])
    mkdir([outputFolderResults '/combined'])
end
if ~isdir([outputFolderResults '/combined_norm'])
    mkdir([outputFolderResults '/combined_norm'])
end
if ~isdir([outputFolderResults '/angio_norm'])
    mkdir([outputFolderResults '/angio_norm'])
end
if ~isdir([outputFolderResults '/struct'])
    mkdir([outputFolderResults '/struct'])
end
if ~isdir([outputFolderResults '/structnorm'])
    mkdir([outputFolderResults '/structnorm'])
end
outputDisp = [outputFolder 'dispersion/'];
if ~isdir(outputDisp)
    mkdir(outputDisp)
end
outputFolderSignal = [outputFolder 'signal/'];
if ~isdir(outputFolderSignal)
    mkdir(outputFolderSignal)
end
outputFolderSpeckVar  = [outputFolder 'speckVar/'];
if ~isdir(outputFolderSpeckVar)
    mkdir(outputFolderSpeckVar)
end