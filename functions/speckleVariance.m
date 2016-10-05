function [speckVar] = speckleVariance(BscansCpx,thr,stdSize)

nFrames = size(BscansCpx,3);
nAscans = size(BscansCpx,2);
FFTSize = size(BscansCpx,1);

% calculate variance
speckVar = zeros(FFTSize,nAscans,floor(nFrames/stdSize));
for ind = 1:floor(nFrames/stdSize)
    speckVar(:,:,ind) = std(abs(BscansCpx(:,:, 1+(ind-1)*stdSize : ind*stdSize)),0,3);
end
speckVar = mean(speckVar,3);

% normalize by the signal level
norm = mean(abs(BscansCpx),3);
norm(norm < thr) = thr;

speckVar = speckVar./norm;


    
