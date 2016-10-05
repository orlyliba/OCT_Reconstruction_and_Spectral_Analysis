function map = sepia(varargin)
%SEPIA  Black-brown-white colormap
%
% Examples:
%   map = sepia;
%   map = sepia(len);
%   B = sepia(A);
%   B = sepia(A, lims);
%
% A colormap designed to replicate the sepia tones of old photographs.
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

% $Id: sepia.m,v 1.2 2009/04/10 13:00:33 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0 5; 0.1 0.05 0 85; 1 0.9 0.8 10; 1 1 1 0];
map = colormap_helper(map, varargin{:});
