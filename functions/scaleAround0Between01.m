function scaledImg = scaleAround0Between01(Img,ext)
Img(Img > ext) = ext;
Img(Img < -ext) = -ext;
scaledImg = Img + ext;
scaledImg = scaledImg/ext/2;
