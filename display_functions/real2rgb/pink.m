function map = pink(len, varargin)
%PINK  Black-pink-white colormap
%
% Examples:
%   map = pink
%   map = pink(len)
%   B = pink(A)
%   B = pink(A, lims)
%
% Similar to MATLAB's pink colormap, but the function can additionally be
% used to convert a real-valued array into a truecolor array using the
% colormap.
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

% $Id: pink.m,v 1.2 2009/04/10 13:00:33 ojw Exp $
% Copyright: Oliver Woodford, 2009

if nargin < 1
   len = size(get(gcf, 'Colormap'), 1);
end
if isscalar(len)
    map = reshape(pink(1:len, [1 len]), [], 3);
    return
end
map = rescale(len(:), varargin{:});
J = map * (2 / 3);
map = [map, map-1/3, map-2/3];
map = max(min(map, 1/3), 0);
map = map + J(:,[1 1 1]);
clear J
map = sqrt(map);
map = reshape(map, [size(len) 3]);
        