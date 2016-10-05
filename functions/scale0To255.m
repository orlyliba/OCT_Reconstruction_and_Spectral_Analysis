function img = scale0To255(img)
img = img - min(img(:));
img = img/max(img(:));
img = img*255;