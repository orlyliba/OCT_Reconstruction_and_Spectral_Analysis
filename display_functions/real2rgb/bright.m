function map = bright(varargin)
%BRIGHT  Black-bright-white colormap
%
% Examples:
%   map = bright
%   map = bright(len)
%   B = bright(A)
%   B = bright(A, lims)
%
% A black to white colormap with several distinct shades of bright color.
% This colormap converts linearly to grayscale when printed in black &
% white.
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

% $Id: bright.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0; 0.3071 0.0107 0.3925; 0.007 0.289 1; 1 0.0832 0.7084;
       1 0.4447 0.1001; 0.5776 0.8360 0.4458; 0.9035 1 0; 1 1 1];
map = colormap_helper(map, varargin{:});