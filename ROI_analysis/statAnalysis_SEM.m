clear; close all; clc;
inputPath = 'C:\MATLAB_Share\Orly\2015\15-03-10 isotype for statistics\Isotype 1-7-15 ext 1p5\spectral\injection sensitivity results\';

pathName = 'C:\MATLAB_Share\Orly\2015\15-03-10 isotype for statistics\Isotype 1-7-15 ext 1p5\spectral\injection sensitivity\';
fileName = dir([pathName '*.mat']);

numberOfVessels = 3;
for timeInd = 1:length(fileName)
    data{timeInd} = [];
end

colors = 'rgbmcy';

for timeInd = 1:length(fileName)
    for vesselInd = 1:numberOfVessels
        load([inputPath fileName(timeInd).name(1:end-4) '_ROI_vessel' num2str(vesselInd) '.mat']);
        data{timeInd,vesselInd} = [255-double(diffBuff)];
        %data{timeInd,vesselInd} = [255-double(diffNormBuff)];        
    end
end
title('all data')
%%
figure;
hold on;
for timeInd = 1:length(fileName)
    for vesselInd = 1:numberOfVessels
        vesselValues(timeInd,vesselInd) = mean(data{timeInd,vesselInd},2);        
    end
    errorbar(timeInd,mean(vesselValues(timeInd,:),2),std(vesselValues(timeInd,:),1,2)/sqrt(numberOfVessels),'.-');
end
title('SEM')
%% ttest
% pre to 2
[h,p] = ttest2(vesselValues(1,:),vesselValues(2,:))
% pre to 3
[h,p] = ttest2(vesselValues(1,:),vesselValues(3,:))
% pre to 4
[h,p] = ttest2(vesselValues(1,:),vesselValues(4,:))


