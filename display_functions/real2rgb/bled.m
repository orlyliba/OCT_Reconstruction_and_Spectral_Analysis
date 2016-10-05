function map = bled(varargin)
%BLED  Black to red variation of the hsv colormap
%
% Examples:
%   map = bled;
%   map = bled(len);
%   B = bled(A);
%   B = bled(A, lims);
%
% A variation of MATLAB's hsv colormap, which starts in black and gradually
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

% $Id: bled.m,v 1.2 2009/04/10 13:00:32 ojw Exp $
% Copyright: Oliver Woodford, 2009

map = [0 0 0; 1 1 0; 0 2 0; 0 3 3; 0 0 4; 5 0 5; 6 0 0] / 6;
map = colormap_helper(map, varargin{:});