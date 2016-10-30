clear; close all; clc;
inputPath = 'C:\MATLAB_Share\Orly\2015\15-03-10 isotype for statistics\Isotype 1-7-15 ext 1p5\spectral\injection sensitivity results\';

pathName = 'C:\MATLAB_Share\Orly\2015\15-03-10 isotype for statistics\Isotype 1-7-15 ext 1p5\spectral\injection sensitivity\';
fileName = dir([pathName '*.mat']);

numberOfVessels = 4;
for timeInd = 1:length(fileName)
    data{timeInd} = [];
end

colors = 'rgbmcy';

figure;
hold on;
for timeInd = 1:length(fileName)
    for vesselInd = 1:numberOfVessels
        load([inputPath fileName(timeInd).name(1:end-4) '_ROI_vessel' num2str(vesselInd) '.mat']);                
         data{timeInd} = [data{timeInd} 255-double(diffBuff)];
        %data{timeInd} = [data{timeInd} 255-double(diffNormBuff)];
         plot(255-double(diffBuff),[colors(vesselInd) '.'])
        %plot(255-double(diffNormBuff),[colors(vesselInd) '.'])        
    end
end
title('all data')
%%
figure;
hold on;
for timeInd = 1:length(fileName)
    errorbar(timeInd,mean(data{timeInd}),std(data{timeInd}),'.-');
end
title('straight forward statistics')

