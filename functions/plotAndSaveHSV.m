function plotAndSaveHSV(imgH, imgS, imgV, figVisEnable, titleStr, outputPath,fileType)
% h = figure;set(h, 'Visible', figVisEnable); 
% imshow(uint8(hsv2rgb(cat(3,imgH,imgS,imgV))))
% title(titleStr);
% if ~isempty(outputPath)
%     saveas(h,outputPath,fileType);
% end
imgV(imgV>255)= 255;
imwrite(uint8(hsv2rgb(cat(3,imgH,imgS,imgV))),[outputPath '.' fileType],fileType);