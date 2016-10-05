function map = copper(varargin)
%COPPER  Black-copper colormap
%
% Examples:
%   map = copper;
%   map = copper(len);
%   B = copper(A);
%   B = copper(A, lims);
%
% Similar to MATLAB's copper function, but also able to return a concise
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
%   map - (len)x3 colormap table.
%   B - size(A)x3 truecolor array.

% $Id: copper.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0 8; 1 0.625 0.398 2; 1 0.7812 0.4975 0];
map = colormap_helper(map, varargin{:});