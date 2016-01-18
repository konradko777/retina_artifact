SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 5:5:45;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
NEURON_ID = 256;
addJava
setGlobals
% global NEURON_IDS
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 10);
% [measureMatrix, artifactIDsMatrix] = cmpMeasureForNeuronMovie(NEURON_ID, 1, 20:5:60, SAMPLES_LIM, algoHandle, measureHandle);


[fullMat, fullArtIDsMat, fullClustArtNumVec] = cmpMeasureForNeuronStruct(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle);
% measureMatrix = squeeze(fullMat(1,:,:));
% % clusterArtifactNo = 1;
% stableThres = getMinimalStableThresholds(measureMatrix, THRESHOLDS, thresBreach20, 3);
% plotMeasureForNeuronMovieThresChoice(measureMatrix, THRESHOLDS, ...
%         artifactIDsMatrix, 99999, [0 10], true, stableThres, true)
% plotMeasureForNeuron(76, MOVIES, THRESHOLDS, fullMat, fullArtIDsMat, fullClustArtNumVec)

% getMinimalStableThreshold(squeeze(fullMat(1, :, :)), THRESHOLDS, thresBreach20, 3)
% stableThresholdsMat = getMinStableThresForMovies(fullMat, MOVIES, THRESHOLDS, thresBreach20, MINIMAL_CLUSTER);
% stableThresVec = chooseStableThresIdx(stableThresholdsMat);
% spikesDetected = detectSpikesForNeuron(NEURON_ID, MOVIES, fullArtIDsMat, stableThresVec, 10, SAMPLES_LIM);

[ fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetected, movieIdx] = ...
    holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle, thresBreach20, 3, 10, 25);

plotMeasureForNeuronChoice(NEURON_ID, MOVIES, THRESHOLDS, ...
        fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, ...
        stableThresVec, movieIdx)



% NEURON_IDS=256;
% for neuronID = NEURON_IDS
%     [measure, artifactsMat, clustVec ] = cmpDotProdForNeuronStruct(neuronID, MOVIES, algoHandle, THRESHOLDS , SAMPLES_LIM); %%%
%     sheetDotProdMeasureStruct(neuronID, MOVIES, THRESHOLDS , measure, artifactsMat, clustVec)
% end