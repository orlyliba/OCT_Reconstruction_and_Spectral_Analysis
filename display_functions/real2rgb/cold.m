function map = cold(varargin)
%COLD  Black-blue-cyan-white colormap
%
% Examples:
%   map = cold;
%   map = cold(len);
%   B = cold(A);
%   B = cold(A, lims);
%
% A black to white colormap through cold shades.
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

% Copyright: Oliver Woodford, 2009
% Based on a colormap by Joseph Kirk, FEX ID: 23865

map = [0 0 0; 0 0 1; 0 1 1; 1 1 1];
map = colormap_helper(map, varargin{:});
