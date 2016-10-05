function map = temp(varargin)
%TEMP  Blue-pale-dark red colormap
%
% Examples:
%   map = temp
%   map = temp(len)
%   B = temp(A)
%   B = temp(A, lims)
%
% A colormap designed by Light & Bartlein for visualizing data such as
% temperature, with good contrast for colorblind viewers.
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

% $Id: temp.m,v 1.3 2009/04/10 13:00:33 ojw Exp $

% Reference:
% A. Light & P.J. Bartlein, "The End of the Rainbow? Color Schemes for
% Improved Data Graphics", EOS Transactions of the American Geophysical
% Union, Vol. 85, No. 40, 5 October 2004.
% http://geography.uoregon.edu/datagraphics/EOS/index.htm

map = [0.142 0 0.850; 0.097 0.112 0.970; 0.160 0.342 1;...
       0.24 0.531 1; 0.34 0.692 1; 0.46 0.829 1;...
       0.6 0.92 1; 0.74 0.978 1; 0.92 1 1; 1 1 0.92;...
       1 0.948 0.74; 1 0.84 0.6; 1 0.676 0.46; 1 0.472 0.34;...
       1 0.24 0.24; 0.97 0.155 0.21; 0.85 0.085 0.187;...
       0.65 0 0.13];
map = colormap_helper(map, varargin{:});