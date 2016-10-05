function map = pink2(varargin)
%PINK2  Black-pink-white colormap
%
% Examples:
%   map = pink2;
%   map = pink2(len);
%   B = pink2(A);
%   B = pink2(A, lims);
%
% A black to white colormap with several distinct shades, most of which
% have a pink tint. This colormap converts linearly to grayscale when
% printed in black & white.
%
% The function can additionally be used to convert a real-valued array into
% a truecolor array using the colormap.
%
% IN:
%   len - Scalar length of the output colormap. If len == Inf the concise
%         table is returned. Default: len = size(get(gcf, 'Colormap'), 1);
%   A - Non-scalar numeric array of real values to be converted into
%       truecolor.
%   lims - 1x2 array of saturation limits to be used on A. Default:
%          [min(A(:)) max(A(:))].
%
% OUT:
%   map - (len)x3 colormap table.
%   B - size(A)x3 truecolor array.

% $Id: pink2.m,v 1.2 2009/04/10 13:00:33 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0; 0.0455 0.0635 0.1801; 0.2425 0.0873 0.1677;...
       0.2089 0.2092 0.2546; 0.3111 0.2841 0.2274; 0.4785 0.3137 0.2624;...
       0.5781 0.3580 0.3997; 0.5778 0.4510 0.5483; 0.5650 0.5682 0.6047;...
       0.6803 0.6375 0.5722; 0.8454 0.6725 0.5855; 0.9801 0.7032 0.7007;...
       1 0.7777 0.8915; 0.9645 0.8964 1; 1 1 1];
map = colormap_helper(map, varargin{:});