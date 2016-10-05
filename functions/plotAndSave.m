function plotAndSaveImg(Img, figVisEnable, titleStr, colorMapOption, outputPath,fileType)
h = figure; set(h, 'Visible', figVisEnable); imagesc(Img); axis equal
title(titleStr)
colormap colorMapOption
saveas(h,outputPath,fileType);