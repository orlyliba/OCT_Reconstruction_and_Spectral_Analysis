function outputFrameNum = getFrameNum(xmlHeader,framesToAvg)
% The number of total frames outputted, depending on the
% desired averaging
if isempty(framesToAvg)
    outputFrameNum = 1;
else
    outputFrameNum =  floor(xmlHeader.Image.SizePixel.SizeY/framesToAvg);
end
