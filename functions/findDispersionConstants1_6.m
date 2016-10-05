function [a2, b2] = findDispersionConstants1_6(k, apodization, interf, ascanAve, outputFolder,params,spectParams,balanceFunc)

nFrames = size(interf,3);
nAscans = size(interf,2);
FFTLength = length(k);
balanceEnable = balanceFunc.balanceEnable;

% Dispersion parameters
a2Inc = params.a2Inc; b2Inc = params.b2Inc;
a2 = params.a2; b2 = params.b2;
MaxIterA = params.MaxIterA; MaxIterB = params.MaxIterB;
framesLimit = min(params.framesLimit,nFrames); % number of frames to process for rapid optimization
minZa = params.minZa; maxZa = params.maxZa;
minXa = params.minXa; maxXa = params.maxXa;
minZb = params.minZb; maxZb = params.maxZb;
if (~isempty(minXa)) && (~isempty(minXa))
    interf = interf(:,1+ascanAve*(minXa-1):ascanAve*maxXa,:);
end

interf = interf(:,:,floor((nFrames-framesLimit)/2)+1:floor((nFrames+framesLimit)/2));
 
% Search dispersion compensation
chdir = 1;
a = [];
Metric = [];
for iter = 1:MaxIterA
    % determine step
    if iter == 1
        % do nothing, a2 = initial value
    elseif iter == 2
        a2 = a2 + (-1)^chdir*a2Inc;
    else
        if Metric(end) > Metric(end-1) % degradation
            chdir = chdir + 1;
        end
        a2 = a2 + (-1)^chdir*a2Inc/chdir;
    end
    a = [a a2];
    dispComp.a2 = a2;
    dispComp.b2 = b2;
    [BscanCpx,~, band1spatial, band2spatial, ~, ~] = calcSpectral2(k, apodization, interf, ascanAve, dispComp, spectParams, nFrames);
    if ~isempty(balanceFunc.func)
        [band1spatial,band2spatial,balanceFunc, h] = balanceBands(balanceEnable,band1spatial,band2spatial,balanceFunc);
    end
    band1spatial = medfilt2(mean(abs(band1spatial),3),[4 4],'symmetric');
    band2spatial = medfilt2(mean(abs(band2spatial),3),[4 4],'symmetric');        
    Metric = [Metric sum(sum(abs(band1spatial(minZa:maxZa,:)-band2spatial(minZa:maxZa,:))))];
    
    if iter == 1
        if ~isempty(outputFolder)
            figure; imagesc(log(mean(abs(BscanCpx),3))); colormap gray
            title(['Dispersion compensation, a_2=' num2str(a2) ', b_2=' num2str(b2) ])
            saveas(gca,[outputFolder '_initial_bscan'],'png');
            figure; imagesc(mean(abs(band1spatial),3)-mean(abs(band2spatial),3)); caxis([-1 1]);
            title(['Dispersion compensation, a_2=' num2str(a2) ', b_2=' num2str(b2) ])
            saveas(gca,[outputFolder '_diff'],'png');
        end
    end
end
if ~isempty(outputFolder)
    figure; plotyy(1:iter,a,1:iter,Metric)
    title('finding a')
    saveas(gca,[outputFolder '_a_calib'],'png');
    figure; imagesc(log(mean(abs(BscanCpx),3))); colormap gray
    title(['Dispersion compensation, a_2=' num2str(a2) ', b_2=' num2str(b2) ])
    saveas(gca,[outputFolder '_bscan_a_calib'],'png');
    figure; imagesc(mean(abs(band1spatial),3)-mean(abs(band2spatial),3)); caxis([-1 1]);
    title(['Dispersion compensation, a_2=' num2str(a2) ', b_2=' num2str(b2) ])
    saveas(gca,[outputFolder '_diff_a_calib'],'png');
end

% chdir = 1;
% b = [];
% Metric = [];
% for iter = 1:MaxIterB
%     % determine step
%     if iter == 1
%         % do nothing, a2 = initial value
%     elseif iter == 2
%         b2 = b2 + (-1)^chdir*b2Inc;
%     else
%         if Metric(end) > Metric(end-1) % degradation
%             chdir = chdir + 1;
%         end
%         b2 = b2 + (-1)^chdir*b2Inc/chdir;
%     end
%     b = [b b2];
%     dispComp.a2 = a2;
%     dispComp.b2 = b2;
%     [BscanCpx,~, band1spatial, band2spatial, ~, ~] = calcSpectral2(k, apodization, interf, 1, dispComp, spectParams, nFrames);
%     if ~isempty(balanceFunc.func)
%         [band1spatial,band2spatial,balanceFunc, h] = balanceBands(balanceEnable,band1spatial,band2spatial,balanceFunc);
%     end
%     band1spatial = medfilt2(mean(abs(band1spatial),3),[4 4],'symmetric');
%     band2spatial = medfilt2(mean(abs(band2spatial),3),[4 4],'symmetric');
%     Metric = [Metric sum(sum(abs(band1spatial(minZb:maxZb,:)-band2spatial(minZb:maxZb,:))))];  
% end
% if ~isempty(outputFolder)
%     figure; plotyy(1:iter,b,1:iter,Metric)
%     title('finding b')
%     saveas(gca,[outputFolder '_b_calib'],'png');
%     figure; imagesc(log(mean(abs(BscanCpx),3))); colormap gray
%     title(['Dispersion compensation, a_2=' num2str(a2) ', b_2=' num2str(b2) ])
%     saveas(gca,[outputFolder '_bscan_b_calib'],'png');
%     figure; imagesc(mean(abs(band1spatial),3)-mean(abs(band2spatial),3)); caxis([-1 1]);
%     title(['Dispersion compensation, a_2=' num2str(a2) ', b_2=' num2str(b2) ])
%     saveas(gca,[outputFolder '_diff_b_calib'],'png');
% end

close all









