function map = thermal(varargin)
%THERMAL  Black-purple-red-yellow-white colormap
%
% Examples:
%   map = thermal;
%   map = thermal(len);
%   B = thermal(A);
%   B = thermal(A, lims);
%
% A colormap designed to replicate the tones of thermal images.
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

% $Id: thermal.m,v 1.2 2009/04/10 13:00:33 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0; 0.3 0 0.7; 1 0.2 0; 1 1 0; 1 1 1];
map = colormap_helper(map, varargin{:});
