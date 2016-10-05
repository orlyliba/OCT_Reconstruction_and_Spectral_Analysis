close all; clear; clc;
pathName = '/home/adlz/Orly/3D for high injection/15-03-04 Lymph GNRs 815 and 925/';
addpath('C:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\lymph_functionsC:\MATLAB_Share\Matlab files for all\Code Package 15-03-08\lymph_functions')
%% Parameters
pixX = 5; %
pixZ = 2;
pixY = 5; % not true to scale
pixOut = 5;
LymphThr = 1500;
FOVRows = 4;
FOVCols = 4;
colorMapOption = 'constHue2'; % colorMapOption options are: parula, jet, hsv, hot, pmkmp, CubicL, IsoL, constHue1, constHue2
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
createTiffsFunction(pathName,create,FOVRows,FOVCols,colorMapOption,pixX,pixZ,pixY,pixOut,LymphThr,diffScaling,relevantRows,outputSuffix)