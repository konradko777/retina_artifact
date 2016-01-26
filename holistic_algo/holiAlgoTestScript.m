SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 5:5:45;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
NEURON_ID = 256;
SPIKE_DET_MARG = 0;
HOW_MANY_SPIKES = 25;
addJava
setGlobals
% global NEURON_IDS
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 10);
% [measureMatrix, artifactIDsMatrix] = cmpMeasureForNeuronMovie(NEURON_ID, 1, 20:5:60, SAMPLES_LIM, algoHandle, measureHandle);


% [fullMat, fullArtIDsMat, fullClustArtNumVec] = cmpMeasureForNeuronStruct(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle);
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

global NEURON_IDS
NEURON_IDS = [76];
for i = 1:length(NEURON_IDS);
    NEURON_ID = NEURON_IDS(i);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetected, movieIdx] = ...
        holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle, thresBreach20, MINIMAL_CLUSTER, SPIKE_DET_MARG, HOW_MANY_SPIKES);
    movieThresArtIDs = fullArtifactIDsMatrix{movieIdx}{stableThresVec(movieIdx)};
    movieThresExclIDs = fullExcludedIDsMatrix{movieIdx}{stableThresVec(movieIdx)};
    movieThresSpikeIDs = fullSpikesIDsMatrix{movieIdx}{stableThresVec(movieIdx)};
%     figure
%     meanAlgoSpike1 = checkAlgorithmOutcome(NEURON_ID, movieIdx, movieThresArtIDs, movieThresExclIDs, movieThresSpikeIDs, -50, SAMPLES_LIM);
%     subplot(3,4, i)
    [meanClustSpike, meanAlgoSpike2, meanAlgoArt] = getMeanClustAndAlgoSpikeForNeuron(NEURON_ID, movieIdx, movieThresArtIDs, SAMPLES_LIM);
%     plotMeanClustAndAlgoSpikeForNeuron(meanClustSpike - meanAlgoArt, meanAlgoSpike2 - meanAlgoArt, NEURON_ID)
%     plotMeasureForNeuronChoice(NEURON_ID, MOVIES, THRESHOLDS, ...
%         fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, ...
%         stableThresVec, spikesDetected, movieIdx)
%     figure
%     hold on
%     plot(meanAlgoSpike1, 'color', 'b')
%     plot(meanClustSpike, 'color', 'g')

end

%Problematyczne neurony
%271 => cos sie popsulo :), cos nie tak z cluster file
%406 => zle klastrowanie
%736 => zmiana elektrody rejestrujace, na 51 (stymulujaca) pomoglo
% NEURON_IDS=256;
% for neuronID = NEURON_IDS
%     [measure, artifactsMat, clustVec ] = cmpDotProdForNeuronStruct(neuronID, MOVIES, algoHandle, THRESHOLDS , SAMPLES_LIM); %%%
%     sheetDotProdMeasureStruct(neuronID, MOVIES, THRESHOLDS , measure, artifactsMat, clustVec)
% end


% for i=1:10
%     figure
%     title(num2str(i))
%     plotMovieElectrode(i, 51)
% end