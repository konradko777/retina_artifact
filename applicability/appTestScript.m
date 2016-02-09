SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 10:5:100;
% THRESHOLDS = 1:25;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
SPIKE_DET_MARG = 0;
HOW_MANY_SPIKES = 25;
% PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\holistic_algo\traces_measure_revised\';
PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\applicability\';
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
NEURON_IDS = [76];
for i = 1:length(NEURON_IDS);
    NEURON_ID = NEURON_IDS(i);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetected, movieIdx] = ...
        holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle, thresBreach20, MINIMAL_CLUSTER, SPIKE_DET_MARG, HOW_MANY_SPIKES);
    artFoundVec = getNOfArtsForMovies(MOVIES, fullArtifactIDsMatrix, stableThresVec);
    plotArtFoundForNeuron(artFoundVec, movieIdx, NEURON_ID);
%     plotMeasureForNeuronChoice(NEURON_ID, MOVIES, THRESHOLDS, ...
%         fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, ...
%         stableThresVec, spikesDetected, movieIdx, PATH_ROOT, COLOR_AXIS_LIM)
end
