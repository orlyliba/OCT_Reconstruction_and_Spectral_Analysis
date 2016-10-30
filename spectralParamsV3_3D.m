% SpectralParamsGanymede

%% Version parameters
OCTSystem = 'Ganymede'; % 'Telesto'
version = 'V4'; % 'sdr'
scanMode = 'speckVar'; %'speckVar'; % 'Bscan', '3D'

%% I/O parameters
inputFolder = '\';
outputFolder = '\';
balanceFuncName = 'balance.mat';
balanceFuncPath = [];
saveBuffers = 1; % needed for creating 3D and analyzing 2D
saveAlgoData = 0; % needed for creating algorithms for explaining the steps in the algorithm
savePng = 0; % needed for saving png figures during processing

%% Spectral analysis parameters
if strcmp(OCTSystem,'Ganymede')
    spectParams.sizeHannBand = 400;
    spectParams.banInc = 50;%100;
    spectParams.start_band = 35;
    spectParams.end_band = 2035;
    spectParams.sizeHannBand1 = 1125;
    spectParams.sizeHannBand2 = 900;
    spectParams.start_band1 = 85;
    spectParams.end_band2 = 1948;   
elseif strcmp(OCTSystem,'Telesto')
    spectParams.sizeHannBand1 = 500;
    spectParams.sizeHannBand2 = 500;
    spectParams.start_band1 = 1;
    spectParams.end_band2 = 1024;
else
    error('ERROR: Wrong OCTSystem name! (spectralParams)')
end
spectParams.apodNormThr = 10;
spectParams.wienerParam = 2;
spectParams.view = 0;
spectParams.GainB1 = 1;

%spectParams.numOfBands = floor((spectParams.end_band - spectParams.start_band + 1 - spectParams.sizeHannBand)/spectParams.banInc)+1;
spectParams.medFiltBandsEnable = 0;
spectParams.medFiltSize = 4;   
spectParams.WienerSpectralNormalization = 1; % if 0, truncated division is performed
spectParams.WienerSpectralNormalizationDamping = 0.05;

%% Dispersion compensation parameters
if strcmp(OCTSystem,'Ganymede')
    dispersionParams.a2 = 8.1/1000;
    dispersionParams.b2 = 7.75/1000;
elseif strcmp(OCTSystem,'Telesto')
    dispersionParams.a2 = -3.3888/1000;
    dispersionParams.b2 = 0/1000;
end
dispersionParams.a2Inc = 1/1000;
dispersionParams.b2Inc = 0.2/1000;
dispersionParams.MaxIterA = 30;
dispersionParams.MaxIterB = 1;
dispersionParams.framesLimit = 10;
dispersionParams.minZa = 250;
dispersionParams.maxZa = 600;
dispersionParams.minXa = 50; % coordinates after ascan averaging, leave empty for full frame
dispersionParams.maxXa = 100;
dispersionParams.minZb = 40;
dispersionParams.maxZb = 700;
dispComp.a2 = dispersionParams.a2; %[]; % Leave empty ([]) to run dispersion comp. algo.
dispComp.b2 = dispersionParams.b2;


%% Balancing parameters
balanceEnable = 1;
balanceFunc.balanceEnable = balanceEnable;
balanceAsFirst = 0;
balanceFunc.func = [];
balanceFunc.ROI = []; % top, bottom, left, right, leave empty to mark the region
balanceFunc.noise = [0 0];
balanceFunc.meanNoiseLevel = [0 0];
balanceFunc.power = 5;
balanceFunc.autoROI = 1;
balanceFunc.exclude_vessels = 1;
balanceFunc.exclude_vessels_thr = 0.4;
balanceFunc.normThr = 0.2;
balanceFunc.stdSize = 5;
balanceFunc.figVisEnable = 'off';
% load([outputFolder 'spectral/' balanceFuncName])

%% Speckle variance
stdSize = 5;
stdLim = stdSize; % number of frames, under which std will not be performed
normThr = 700;

%% Display and scaling
figVisEnable = 'off'; % 'off'or 'on'
trueToScale = 0;
reSizeMethod = 'bilinear';
frames2Avg2D = [];%[]; % leave empty ([]) to average all frames in Bscan
viewRange = [30:800]; % before rescaling to TrueToScale
scanLabelVisEnable = 'on';
frames2Avg3D = 1; % averaging of frames at different locations
additionalFrameAvgOverlap = 0; % on every side
%% specific display parameters
diffScale = 0.5; % ext
diffNormScale = 0.5;
thrSpeckVar = 0.2;
maxSpeckVar = 0.3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                             CODE                                               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Add paths
addpath('\');
addpath(pwd '\xml_io_tools\');
addpath([pwd '/functions/']);
%% Load version specific stuff
if strcmp(OCTSystem,'Ganymede')
    load('Chirp_Ganymede.mat')
    filt = [];
elseif strcmp(OCTSystem,'Telesto')
    load('Chirp_Telesto.mat')
    filt = hann(length(chirp_vect));
else
    error('ERROR: Wrong OCTSystem name! (spectralParams)')
end

if strcmp(version,'V4')
    filesToRun = dir([inputFolder]);
    fileStartInd = 3;
elseif strcmp(version,'sdr')
    error('ERROR: SDR not supported in this version. Please try an older version of the code.')
else
    error('ERROR: Wrong version! (runspectral)')
end

FFT_length = length(chirp_vect);
kVect = fliplr(chirp_vect');
k = fliplr([0:1:FFT_length-1]);

switch scanMode
    case {'speckVar','3D'}
        frames2Avg = frames2Avg3D;
    case 'Bscan'
        additionalFrameAvgOverlap = 0;
        frames2Avg = frames2Avg2D;
end
save('tempWorkSpace')
