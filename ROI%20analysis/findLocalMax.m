function [map] = findLocalMax(ROI,threshold)
Dx = ROI(2:end-1,1:end-1) - ROI(2:end-1,2:end);
Dy = ROI(1:end-1,2:end-1) - ROI(2:end,2:end-1);
map = zeros(size(ROI));
map(2:end-1,2:end-1) = (Dx(:,1:end-1).*Dx(:,2:end) < 0) & (Dy(1:end-1,:).*Dy(2:end,:) < 0) & (ROI(2:end-1,2:end-1) > threshold);
% figure; imagesc(map); colormap gray;
% figure; imagesc(ROI(2:end-1,2:end-1)); colormap gray;

