function map = earth(varargin)
%EARTH  Black-green-white colormap
%
% Examples:
%   map = earth;
%   map = earth(len);
%   B = earth(A);
%   B = earth(A, lims);
%
% A black to white colormap with several distinct shades, most of which
% have a green or brown tint. This colormap converts linearly to grayscale
% when printed in black & white.
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

% $Id: earth.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0; 0 0.1104 0.0583; 0.1661 0.1540 0.0248; 0.1085 0.2848 0.1286;...
       0.2643 0.3339 0.0939; 0.2653 0.4381 0.1808; 0.3178 0.5053 0.3239;...
       0.4858 0.5380 0.3413; 0.6005 0.5748 0.4776; 0.5698 0.6803 0.6415;...
       0.5639 0.7929 0.7040; 0.6700 0.8626 0.6931; 0.8552 0.8967 0.6585;...
       1 0.9210 0.7803; 1 1 1];
map = colormap_helper(map, varargin{:});