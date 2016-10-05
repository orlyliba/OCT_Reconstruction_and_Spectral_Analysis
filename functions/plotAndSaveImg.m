function plotAndSaveImg(Img, figVisEnable, titleStr, colorMapOption, caxisRange, outputPath,fileType)
% h = figure; set(h, 'Visible', figVisEnable); imagesc(Img); axis equal
% title(titleStr);
% colormap(colorMapOption);
% if ~isempty(caxisRange)
%     caxis(caxisRange);
% end
% if ~isempty(outputPath)
%     saveas(h,outputPath,fileType);
% end

Img = Img - min(Img(:));
Img = Img/max(Img(:))*255;
Img = uint8(Img);
imwrite(Img,[outputPath '.' fileType],fileType);

