function I = hsv2colormap(H,S,V,colorMapOption)
% colorMapOption options are: parula, jet, hsv, hot, pmkmp, CubicL, IsoL,
% constHue1, constHue2
addpath('C:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\display_functions\')
addpath('C:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\display_functions\mat2im\')
addpath('C:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\display_functions\pmkmp\pmkmp\')
addpath('C:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\display_functions\real2rgb\')

hueVal1 = 0.25; % green
hueVal2 = 0.75; % green

if ~ (strcmp(colorMapOption,'constHue1') || strcmp(colorMapOption,'constHue2'))
    switch colorMapOption
        case 'parula'
            load_parula;
            J= parula;
            rgbH = mat2im((1-H)*255,J);
        case 'hsv'
            J= hsv(256);
            rgbH = mat2im(H*255,J);
        case 'jet'
            J= jet(256);
            rgbH = mat2im((1-H)*255,J);
        case 'hot'
            J= hot(256);
            rgbH = mat2im((1-H)*255,J);
        case 'pmkmp'
            J= pmkmp(256);
            rgbH = mat2im((1-H)*255,J);
        case 'CubicL'
            J = pmkmp(256,'CubicL');
            rgbH = mat2im((1-H)*255,J);
        case 'IsoL'
            J = pmkmp(256,'IsoL');
            rgbH = mat2im((1-H)*255,J);
    end
    hsvH = rgb2hsv(rgbH);
    H = hsvH(:,:,1);
else
    h = (0.5 - H)/0.5;
    H = hueVal1*ones(size(H));
    if strcmp(colorMapOption,'constHue1')
        h(h<0) = 0;
        S = S.*h;
    elseif strcmp(colorMapOption,'constHue2')
        S(h>0) = S(h>0).*h(h>0);
        S(h<0) = S(h<0).*(-h(h<0));
        S = S*2; % further enhancement
        H(h<0) = hueVal2;
    end
end
I = hsv2rgb(cat(3,H,S,V));
