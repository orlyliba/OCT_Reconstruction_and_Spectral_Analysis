function [avgROI, stdROI, pos, histROI, a] = getRectAvg
rect = getrect;
xmin = rect(1);
ymin = rect(2);
width = rect(3);
height = rect(4);
pos = [xmin+width/2 ymin+height/2];
I=getimage();
a = I(ymin:ymin+height-1,xmin:xmin+width-1);
a = a(:);
[N,X] = hist(a);
avgROI = mean(a);
stdROI = std(a);
histROI = [N;X];
figure; bar(histROI(2,:),histROI(1,:))
title(['mean = ' num2str(avgROI) ' std = ' num2str(stdROI)])

