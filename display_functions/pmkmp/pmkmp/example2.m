%% Example 2
%
% In this example I compare several displays of the same geophysical data: 
% I used the cubic L colormap from this submission, I used the iso L colrmap,
% again from this submission, and I used Matlab's Jet
% 
% For data I used a map of Bouguer gravity residual anomaly (i.e. after the
% removal of a regional trend from Bouguer gravity). For the shading I did
% not use lighting, but instead I calculated the terrain slope (one of the
% many flavors of first derivative) and used the very good FEX submission 
% "shaded pseudo color", which you can find at:
% www.mathworks.cn/matlabcentral/fileexchange/14157-shaded-pseudo-color
%
% Figures:
% - example2_fig1.png
%   this is the result using Jet
%   There are two very evident breaks in the surface, which I indicated with 
%   arrows. These are not really present in the data. They are artifacts
%   introduced by the Jet colormap. It is the recognition of these artifacts
%   that prompted me to research into a better colormap. They are quite
%   distinguisheable in the colorbar as well, and I marked them there too.
%   These are the inversions in the Luminance i describe in the help for pmkmp. 
%   Please also refer to examples.m and the figure L_plot_for_jet_colormap.png
%
% - example2_fig2.png
%   this is the result using isoL
%   Now the the color gradation does not produce those false edges in the
%   image. That is a significant result because the eye is naturally drawn
%   to edges and artificially introducing them with the colormap is confusing
%   to the viewer and distracting from the task of interpreting results.
%
%  - example2_fig3.png
%    this is the result using cubicL
%    In here too the edges are not present. Please also notice that I like
%    the color discrimination afforded by this colorbar more than with the
%    isoluminant above, even though authors in the reference papers usggest
%    that the isoluminant colorbar is the most appropriate when using
%    shading or illumination. This may be specific to this particular dataset
%    or a more general observation, it will require more examples
%
%
% ******* NOTICE:
% This dataset was part of a field project and research thesis from my degree
% in Geology at the University of Rome "La Sapienza". 
% Because the results are still unpublished I am not including the data with 
% the example. However, here below is how the code I used looked like, for 
% instance for example2_fig3.png. The variable with data would be 'residual'
% and the variable with the slope would be 'normalized_slope' (I normalized
% the slope to [0 1]). I then calculated the complement of the normalized 
% slope so that the darkest shades in the final map would be where the slope
% is highest
%
% % figure;
% % slp=1-normalized_slope;
% % shadedpcolor(x,y,residual,slp,[clim residual],[clim slp],0.55,jet(256),0);
% % axis equal; axis off; axis tight;
% % shadedcolorbar([clim residual],0.55,jet(256));
%
%
%