function map = dusk(varargin)
%DUSK  Black-blue-green-gray-red-yellow-white colormap
%
% Examples:
%   map = dusk;
%   map = dusk(len);
%   B = dusk(A);
%   B = dusk(A, lims);
%
% A black to white colormap with several distinct pastel shades reminiscent
% of colors at dusk. This colormap converts linearly to grayscale when
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
%   map - (len)xJ colormap table. J = 3, except in the concise case, when
%         J = 4, map(1:end-1,4) giving the relative sizes of the 
%         inter-color bins.
%   B - size(A)x3 truecolor array.

% Copyright: Oliver Woodford, 2009

map = [0 0 0 114; 0 0 0.5 587; 0 0.5 0.5 299; 0.5 0.5 0.5 299; 1 0.5 0.5 587; 1 1 0.5 114; 1 1 1 0];
map = colormap_helper(map, varargin{:});