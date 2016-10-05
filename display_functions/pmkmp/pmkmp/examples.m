%% this cell creates three figures that display the same topographic surface
% using three different colormaps: the standard  Jet, and the CubicL and isoL 
% from this submission. CubicL is intended as an improvement over Jet for
% display of interval data without external illumination; isoL is intended
% as the to be used in conjunction with illumination. Please see pmkmp help
% for more details

set(0,'defaultfigureunits','pixels');
load cape;
topo=X;
topo1=topo; topo1(X>=100)=100;
x=1:1:360;
[X,Y] = meshgrid(x,x);

fig1 = figure;
surf(X,Y,topo,topo1,'FaceColor','interp','EdgeColor','none');
colormap(jet(256));
set(gca,'YDir','reverse');
axis off
daspect([0.5 0.5 2.25]);
view(10,45);
material shiny;
set(fig1,'Position',[720 400 950 708]);
set(fig1,'OuterPosition',[716 396 958 790]);
title('Standard Matlab rainbow (jet)','Color','k','FontSize',12,'FontWeight','demi');
colorbar;

map2=pmkmp(256, 'isol');
fig2 = figure;
surf(X,Y,topo,topo1,'FaceColor','interp','EdgeColor','none');
colormap(map2);
set(gca,'YDir','reverse');
axis off
daspect([0.5 0.5 2.25]);
view(10,45);
lighting phong;
material shiny;
k=lightangle(10,55);
% lightangle(k, 200, 70);
set(fig2,'Position',[720 400 950 708]);
set(fig2,'OuterPosition',[716 396 958 790]);
title('Isoluminant rainbow with L*=60','Color','k','FontSize',12,'FontWeight','demi');
colorbar;

map3=pmkmp(256);
fig3 = figure;
surf(X,Y,topo,topo1,'FaceColor','interp','EdgeColor','none');
colormap(map3);
set(gca,'YDir','reverse');
axis off
daspect([0.5 0.5 2.25]);
view(10,45);
material shiny;
set(fig3,'Position',[720 400 950 708]);
set(fig3,'OuterPosition',[716 396 958 790]);
title('Cubic law L* rainbow','Color','k','FontSize',12,'FontWeight','demi');
colorbar;

%% this cell makes figure to display World topography using Edge Colors colormap
load topo;
M=abs(max(max(topo)));
m=abs(min(min(topo)));

% this bit below establishes anchor to centre colormap (white) at zero
if M-m>=0       
   lm=[-m m];
   else
   lm=[-M M];
end

map4=pmkmp(256,'edge');
fig4 = figure;
imagesc(flipud(topo),[lm]);
axis equal
axis tight
axis off
set(fig4,'Position',[720 400 980 580]);
title('Edge Colors','Color','k','FontSize',12,'FontWeight','demi');
colormap(map4);
colorbar;
