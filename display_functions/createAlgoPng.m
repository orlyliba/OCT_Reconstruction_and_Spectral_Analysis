close all; clear; clc;
pathName = 'C:\MATLAB_Share\Orly\2015\15-03-08 GNRs in blood new analysis\Test\spectral\algo figs\';
fileName = dir([pathName '*.mat']);
for fileInd  = 1:length(fileName)
    disp(fileName(fileInd).name)
    load([pathName fileName(fileInd).name]);
end

%%
figure;
imagesc(band1BeforeDispersionBeforeBalance - band2BeforeDispersionBeforeBalance);
caxis([-1 1]);
title('Before dispersion')
colormap jet
saveas(gca,[pathName 'Before dispersion'],'png')
%%
figure;
imagesc(band1AfterDispersionBeforeBalance - band2AfterDispersionBeforeBalance);
caxis([-1 1]);
title('After dispersion, before balance')
colormap jet
saveas(gca,[pathName 'After dispersion before balance'],'png')
%%
figure;
imagesc(band1AfterBalance - band2AfterBalance);
caxis([-1 1]);
title('After balance')
colormap jet
saveas(gca,[pathName 'After balance'],'png')
%%
lambda = linspace(800,1000,2048);
lambda = fliplr(lambda);
figure; 
plot(lambda,interf1/max(interf1(:)),'k');
hold on;
plot(lambda(indicesBand1),winHannBand1,'r')
plot(lambda(indicesBand2),winHannBand2,'b')
legend('spectrum','Band 1','Band 2')
xlabel('\lambda')
saveas(gca,[pathName 'spectral bands'],'png')
