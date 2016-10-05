function map = pastel(varargin)
%PASTEL  Black-pastel-white colormap
%
% Examples:
%   map = pastel;
%   map = pastel(len);
%   B = pastel(A);
%   B = pastel(A, lims);
%
% A black to white colormap with several distinct pastel shades. This
% colormap converts linearly to grayscale when printed in black & white.
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

% $Id: pastel.m,v 1.2 2009/04/10 13:00:33 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0; 0.4709 0 0.018; 0 0.3557 0.6747; 0.8422 0.1356 0.8525;
       0.4688 0.6753 0.3057; 1 0.6893 0.0934; 0.9035 1 0; 1 1 1];
map = colormap_helper(map, varargin{:});