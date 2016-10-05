function map = whed(varargin)
%WHED  White to red variation of the hsv colormap
%
% Examples:
%   map = whed;
%   map = whed(len);
%   B = whed(A);
%   B = whed(A, lims);
%
% A variation of MATLAB's hsv colormap, which starts in white and gradually
% increases in color saturation.
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

% Copyright: Oliver Woodford, 2010

map = [6 6 6; 6 6 5; 4 6 4; 3 6 6; 2 2 6; 6 1 6; 6 0 0] / 6;
map = colormap_helper(map, varargin{:});