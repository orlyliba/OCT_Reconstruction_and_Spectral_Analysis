close all; clear; clc;
pathName = 'C:\MATLAB_Share\Orly\2015\15-03-08 GNRs in blood new analysis\Test\spectral\Bscan process/';
addpath('C:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\lymph_functions\')
%% Parameters
LymphThr = 1500;
colorMapOption = 'parula'; % colorMapOption options are: parula, jet, hsv, hot, pmkmp, CubicL, IsoL, constHue1, constHue2
diffScaling = 1; % scale the diff map
outputSuffix = colorMapOption;
relevantRows = [50:600];
%% Actions
create.Combined = 1;
create.CombinedNorm = 0;
create.Angio = 1;
create.AngioNorm = 1;
create.Logsignal = 0;
create.Structure = 0;
create.Lymph = 0;
create.LymphCombined = 0;
create.SpeckVarRaw = 0;
%%
createPngBscanFunction(pathName,create,colorMapOption,LymphThr,diffScaling,relevantRows,outputSuffix)