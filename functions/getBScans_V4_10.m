function [xml_header, params, interfAll, avgLogBscan, linBscan, BscansCpx, apodization, timeStamp] = getBScans_V4_10(fileAndPath,xml_header,chirpVect,dispComp,frameRange,filt)

k_n = flipud(chirpVect);
N = length(k_n);
m = 0:N-1;
[K, M] = meshgrid(k_n,m(1:end/2));
TempFFTM = exp(2*pi*1i.*M.*K/N);
%%
params.size.x = xml_header.Image.SizePixel.SizeX;
if  isfield( xml_header.Image.SizePixel,'SizeY')
    params.size.y = xml_header.Image.SizePixel.SizeY;
else
    params.size.y = 1;
end
if isempty(frameRange)
    numOfFrames = params.size.y;
    frameRange = 1:numOfFrames;    
else
    numOfFrames = length(frameRange);
end
params.size.z = xml_header.Image.SizePixel.SizeZ;
spectralInd = 0;
for ind = 1:length(xml_header.DataFiles.DataFile)
    if strcmp(xml_header.DataFiles.DataFile(ind).CONTENT(1:13),'data\Spectral')
        spectralInd = ind;
    end
end
if spectralInd == 0
    error('ERROR: getBscan, missing raw spectral data in folder')
end
interf_size = xml_header.DataFiles.DataFile(spectralInd).ATTRIBUTE.SizeX;
apod_size = xml_header.DataFiles.DataFile(spectralInd).ATTRIBUTE.ApoRegionEnd0;
params.avg.spectra = xml_header.Acquisition.IntensityAveraging.Spectra;
params.avg.ascan = xml_header.Acquisition.IntensityAveraging.AScans;
params.avg.bscan = xml_header.Acquisition.IntensityAveraging.BScans;
timeStamp = getTimeStamp(num2str(xml_header.Acquisition.Timestamp));

width_image = params.size.x;
ascan_ave = params.avg.ascan;
ascan_binning = params.avg.spectra;
BscansCpx=zeros(N/2,width_image*ascan_ave,numOfFrames);
linBscan=zeros(N/2,width_image,numOfFrames);
interfAll = zeros(N,width_image*ascan_ave,numOfFrames);
apodization = zeros(N,apod_size,numOfFrames);
if isempty(filt)
    filt = ones(N,width_image*ascan_ave);
else
    filt = repmat(filt,[1,width_image*ascan_ave]);
end

%dispersion compensation
a2 = dispComp.a2; 
Phase = exp(1i*(a2*k_n'.^2/N))';
Phase = repmat(Phase,[1 width_image*ascan_ave 1]);

buffInd = 1;
avgLogBscan = 0;
for frameInd = frameRange
    fid = fopen([fileAndPath '/data/Spectral' num2str(frameInd-1) '.data']);
    temp = fread(fid,inf,'short');
    fclose(fid);
    
    size_arr = [N,interf_size];
    temp = reshape(temp,size_arr);    
    apodization(:,:,buffInd) = flipud(temp(:,1:apod_size));
    interf = flipud(temp(:,apod_size+1:end));    
    
    apod = mean(apodization(:,:,buffInd),2);    
    interf = interf - repmat(apod,1,width_image*ascan_ave*ascan_binning);   
    avgFilt = ones(1,ascan_binning)/(ascan_binning);
    interfAvg = filter2(avgFilt,interf);
    % interfAvg = interfAvg(:,max(1,floor((ascan_binning)/2)):ascan_binning:end);
    interfAvg = interfAvg(:,max(1,floor((ascan_binning)/2)):ascan_binning:end);    
    interfAvg = interfAvg.*filt;
    interfAll(:,:,buffInd) = interfAvg;
    % interfAll(:,:,frameInd) = interf;     
    %process bscan
    BscansCpx(:,:,buffInd) = TempFFTM*(interfAvg.*Phase); 
    
    avgFilt = ones(1,ascan_ave)/(ascan_ave);
    bscanAvg = filter2(avgFilt,abs(BscansCpx(:,:,buffInd)));
    bscanAvg = bscanAvg(:,max(1,floor((ascan_ave)/2)):ascan_ave:end,:);
    linBscan(:,:,buffInd) = bscanAvg;
    avgLogBscan = avgLogBscan + abs(bscanAvg);
    
    buffInd = buffInd + 1;
end

avgLogBscan = 20*log10(avgLogBscan/length(frameRange));

% figure; imagesc(Bscan); colormap gray;