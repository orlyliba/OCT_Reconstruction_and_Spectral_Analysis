function map = autumn(varargin)
%AUTUMN  Red-yellow colormap
%
% Examples:
%   map = autumn;
%   map = autumn(len);
%   B = autumn(A);
%   B = autumn(A, lims);
%
% Similar to MATLAB's autumn function, but also able to return a concise
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

% $Id: autumn.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [1 0 0; 1 1 0];
map = colormap_helper(map, varargin{:});
