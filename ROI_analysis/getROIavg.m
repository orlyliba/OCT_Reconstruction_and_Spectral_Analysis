function [avgROI stdROI pos histROI a] = getROIavg
[BW x y] = roipoly;
pos = [x y];
norm = sum(BW(:));
I=getimage();
a = I.*BW;
a = a(:);
a(a==0) = [];
[N,X] = hist(a);
avgROI = mean(a);
stdROI = std(a);
histROI = [N;X];
figure; bar(histROI(2,:),histROI(1,:))
title(['mean = ' num2str(avgROI) ' std = ' num2str(stdROI)])

