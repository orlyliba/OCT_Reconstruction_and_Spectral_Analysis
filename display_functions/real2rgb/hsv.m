function map = hsv(varargin)
%HSV  Red-yellow-green-cyan-blue-magenta-red colormap
%
% Examples:
%   map = hsv;
%   map = hsv(len);
%   B = hsv(A);
%   B = hsv(A, lims);
%
% Similar to MATLAB's hsv function, but also able to return a concise
% colormap table.
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

% $Id: hsv.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [1 0 0; 1 1 0; 0 1 0; 0 1 1; 0 0 1; 1 0 1; 1 0 0];
map = colormap_helper(map, varargin{:});
