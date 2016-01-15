SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 20:5:60;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
addJava
setGlobals
% global NEURON_IDS
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
% [measureMatrix, artifactIDsMatrix] = cmpMeasureForNeuronMovie(76, 1, 20:5:60, SAMPLES_LIM, algoHandle, measureHandle);

% [fullMat, fullArtIDsMat, fullClustArtNumVec] = cmpMeasureForNeuronStruct(76, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle);
% plotMeasureForNeuron(76, MOVIES, THRESHOLDS, fullMat, fullArtIDsMat, fullClustArtNumVec)
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 10);
% getMinimalStableThreshold(squeeze(fullMat(1, :, :)), THRESHOLDS, thresBreach20, 3)
% stableThresholdsMat = getMinStableThresForMovies(fullMat, MOVIES, THRESHOLDS, thresBreach20, MINIMAL_CLUSTER);
% for i=1:length(stableThresholdsMat)
%     stableThresholdsMat{i}
%     
% end
% NEURON_IDS=256;
% for neuronID = NEURON_IDS
%     [measure, artifactsMat, clustVec ] = cmpDotProdForNeuronStruct(neuronID, MOVIES, algoHandle, THRESHOLDS , SAMPLES_LIM); %%%
%     sheetDotProdMeasureStruct(neuronID, MOVIES, THRESHOLDS , measure, artifactsMat, clustVec)
% end