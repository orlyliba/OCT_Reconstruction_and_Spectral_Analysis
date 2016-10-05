function [speckVar] = speckleVarianceAscans(BscansCpx,ascanAve,thr)

nFrames = size(BscansCpx,3);
if nFrames > 1
    error('when calculating ascan speckle variance, the number of frames must be 1')
end
nAscans = floor(size(BscansCpx,2)/ascanAve);
depth = size(BscansCpx,1);

% calculate variance of all Ascans in the same location
speckVar = zeros(depth,nAscans);
for ind = 1:nAscans
    speckVar(:,ind) = std(abs(BscansCpx(:,1+(ind-1)*ascanAve : ind*ascanAve)),0,2);
end

% normalize by the signal level
avgFilt = ones(1,ascanAve)/(ascanAve);
bscanAvg = filter2(avgFilt,abs(BscansCpx(:,:)));
bscanAvg = bscanAvg(:,max(1,floor((ascanAve)/2)):ascanAve:end);
norm = bscanAvg;
norm(norm < thr) = thr;

speckVar = speckVar./norm;


    
