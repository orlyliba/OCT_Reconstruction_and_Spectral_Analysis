function [avgROI, stdROI, pos, histROI, a] = getStatsFromRect(x1,y1,x2,y2)
xmin = min(x1,x2);
ymin = min(y1,y2);
width = abs(x2-x1)+1;
height = abs(y2-y1)+1;
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

