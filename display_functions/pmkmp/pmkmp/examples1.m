%% This cell creates the Great Pyramid of Khufu in Giza, using the original
%(pre-erosion) dimensions of 755x755x482 feet (I am using imperial measurements
% as they are round numbers - metrics measurements are not)

PY=zeros(241,241);
for i = 1:241
    temp=(0:1:i-1);
      PY(i,1:i)=temp(:);
end
    
test=PY.';
test=test-1;
test(test==-1)=0;
test1=test([2:1:end,1],:);
PY1=PY+test1;
PY2=fliplr(PY1);
PY3= flipud(PY1);
PY4=fliplr(PY3);
GIZA=[PY1,PY2;PY3,PY4].*2;

x=linspace(1,756,size(GIZA,1));
y=x;
[X,Y]=meshgrid(x,y);
clear i test test1 PY PY1 PY2 PY3 PY4 temp;




%% This cell plots the pyramid with SURF (interpolated color) using Jet, 
% Spectrum, and CubicL colormaps in Figure 1, Figure 2, and  Figure 3
% respectively. Because this is a perfect geometric surface, there should
% be no discontinuities in how the rendered surface color is perceived by
% the viewer. This is only true, or at least more so, with CubicL.

fig1=figure;
surf(X,Y,GIZA,GIZA,'FaceColor','interp','EdgeColor','none');
view(-35,70);
colormap(jet(256));
axis off;
grid off;
colorbar;
% set(fig1,'Position',[720 400 950 708]);
% set(fig1,'OuterPosition',[716 396 958 790]);
title('Standard Matlab rainbow (jet)','Color','k','FontSize',12,'FontWeight','demi');

% for the spectrum below I used the RGB triplets from CIE 1964 10-deg XYZ
% Please refer to the FEX submission Spectral and XYZ Color Functions - link provided
% in the help menu for pmkmp
RGB=[0.1127         0    0.3515
     0.2350         0    0.6663
     0.3536         0    1.0000
     0.4255         0    1.0000
     0.4384         0    1.0000
     0.3888         0    1.0000
     0.2074         0    1.0000
          0         0    1.0000
          0    0.4124    1.0000
          0    0.6210    1.0000
          0    0.7573    0.8921
          0    0.8591    0.6681
          0    0.9642    0.4526
          0    1.0000    0.1603
          0    1.0000         0
          0    1.0000         0
          0    1.0000         0
          0    1.0000         0
     0.4673    1.0000         0
     0.8341    1.0000         0
     1.0000    0.9913         0
     1.0000    0.8680         0
     1.0000    0.7239         0
     1.0000    0.5506         0
     1.0000    0.3346         0
     1.0000         0         0
     1.0000         0         0
     1.0000         0         0
     1.0000         0         0
     0.9033         0         0
     0.7412         0         0
     0.5902         0         0];
Spectrum=interp1(linspace(1, 256, 32),RGB,[1:1:256]);

fig2=figure;
surf(X,Y,GIZA,GIZA,'FaceColor','interp','EdgeColor','none');
view(-35,70);
colormap(Spectrum);
axis off;
grid off;
colorbar;
% set(fig2,'Position',[720 400 950 708]);
% set(fig2,'OuterPosition',[716 396 958 790]);
title('CIE 1964 10-deg Spectrum (visible range)','Color','k','FontSize',12,'FontWeight','demi');

fig3=figure;
surf(X,Y,GIZA,GIZA,'FaceColor','interp','EdgeColor','none');
view(-35,70);
colormap(pmkmp(256));
axis off;
grid off;
colorbar;
% set(fig3,'Position',[720 400 950 708]);
% set(fig3,'OuterPosition',[716 396 958 790]);
title('Cubic law L* rainbow','Color','k','FontSize',12,'FontWeight','demi');
