SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 10:5:100;
% THRESHOLDS = 1:25;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
SPIKE_DET_MARG = 0;
HOW_MANY_SPIKES = 25;
% PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\holistic_algo\traces_measure_revised\';
PATH_ROOT = 'G:\';
addJava
setGlobals
% global NEURON_IDS
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 30);
% movies76 = [4 5 9 13 23];
AMP_DICT = createNeuronSpikeAmpDict();
Y_LIM_DICT = createNeuronYLimDict();
COLOR_AXIS_LIM = [0 300];
% movies76 = [4];
global NEURON_IDS
% NEURON_IDS = [76];
for i = 1:length(NEURON_IDS);
    NEURON_ID = NEURON_IDS(i);
    neuronStr = num2str(NEURON_ID);
    suffix = '_big_thres';
    fullPath = [PATH_ROOT neuronStr suffix '\'];
    mkdir(fullPath);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetected, movieIdx] = ...
        holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle, thresBreach20, MINIMAL_CLUSTER, SPIKE_DET_MARG, HOW_MANY_SPIKES);
    for movie = MOVIES
        fullPathMovie = [fullPath num2str(movie) '\'];
        mkdir(fullPathMovie);
        bestThreshold = stableThresVec(movie);
        movieMeasureMat = squeeze(fullMeasureMatrix(movie, :, :));
        movieArtIDs = fullArtifactIDsMatrix{movie};
        movieExclIDs = fullExcludedIDsMatrix{movie};
        movieSpikeIDs = fullSpikesIDsMatrix{movie};
        for thresholdArrowIdx = 1:length(THRESHOLDS)
            plotTracesAndMeasureArrow(NEURON_ID, movie, thresholdArrowIdx, movieMeasureMat, ...
                movieArtIDs, movieExclIDs, movieSpikeIDs, bestThreshold, AMP_DICT(NEURON_ID), ...
                SAMPLES_LIM, THRESHOLDS, fullPathMovie, COLOR_AXIS_LIM, movieIdx, Y_LIM_DICT(NEURON_ID));
        end
    end
%     figure
%     meanAlgoSpike1 = checkAlgorithmOutcome(NEURON_ID, movieIdx, movieThresArtIDs, movieThresExclIDs, movieThresSpikeIDs, -50, SAMPLES_LIM);
%     subplot(3,4, i)
%     [meanClustSpike, meanAlgoSpike2, meanAlgoArt] = getMeanClustAndAlgoSpikeForNeuron(NEURON_ID, movieIdx, movieThresArtIDs, SAMPLES_LIM);
%     plotMeanClustAndAlgoSpikeForNeuron(meanClustSpike - meanAlgoArt, meanAlgoSpike2 - meanAlgoArt, NEURON_ID)
    plotMeasureForNeuronChoice(NEURON_ID, MOVIES, THRESHOLDS, ...
        fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, ...
        stableThresVec, spikesDetected, movieIdx, fullPath, COLOR_AXIS_LIM)

end
