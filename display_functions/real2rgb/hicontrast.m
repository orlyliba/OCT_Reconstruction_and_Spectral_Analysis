function map = hicontrast(varargin)
%HICONTRAST  Black-blue-red-magenta-green-cyan-yellow-white colormap
%
% Examples:
%   map = hicontrast;
%   map = hicontrast(len);
%   B = hicontrast(A);
%   B = hicontrast(A, lims);
%
% A colormap designed to maximize the range of colors used in order to
% improve contrast between intensity levels, while converting linearly to
% grayscale, such that black & white prints come out nicely.
%
% The function can additionally be used to convert a real valued array into
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

% $Id: hicontrast.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0 114; 0 0 1 185; 1 0 0 114; 1 0 1 174;...
       0 1 0 114; 0 1 1 185; 1 1 0 114; 1 1 1 0];
map = colormap_helper(map, varargin{:});
