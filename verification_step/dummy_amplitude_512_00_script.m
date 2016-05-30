SAMPLES_LIM = [8 37];
MOVIES = 1:2:63;
THRESHOLDS = 10:5:100;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
SPIKE_DET_MARG = 30;
HOW_MANY_SPIKES = 25;
PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\512_00\';
addJava
setGlobals512_00
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 30);
global NEURON_SPIKE_AMP_MAP
global NEURON_REC_ELE_MAP NEURON_ELE_MAP
SPIKE_DETECTION_THRES_DICT = createDetectionThresFromSpikeAmp(NEURON_SPIKE_AMP_MAP);
COLOR_AXIS_LIM = [0 300];
global NEURON_IDS
fullArtIdxMatrices = cell(size(NEURON_IDS));
fullSpikeIdxMatrices = cell(size(NEURON_IDS));
fullExcludedIdxMatrices = cell(size(NEURON_IDS));
fullDetectedSpikesIdxMatrices = cell(size(NEURON_IDS));
stableThresVectors = cell(size(NEURON_IDS));
chosenMovies = zeros(size(NEURON_IDS));
nOfSpikesDetected = cell(size(NEURON_IDS));
%TODO 40th(id: 2017) neuron is causing problems, probably due to not
% enaough artifacts found
stabilityIslands = cell(size(NEURON_IDS));
DUMMY_AMPLITUDE = -20;
for i = 1:length(NEURON_IDS);
    i
    NEURON_ID = NEURON_IDS(i);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, ...
        fullClustArtNumVec, stableThresVec, spikesDetectedVec, fullSpikesDetectedIdxMat, movieIdx, neuronStabilityIslands] = ...
        holisticAlgo512(MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle,...
        thresBreach20, MINIMAL_CLUSTER, HOW_MANY_SPIKES, DUMMY_AMPLITUDE,...
        NEURON_REC_ELE_MAP(NEURON_ID), NEURON_ELE_MAP(NEURON_ID));
    fullArtIdxMatrices{i} = fullArtifactIDsMatrix;
    fullSpikeIdxMatrices{i} = fullSpikesIDsMatrix;
    fullExcludedIdxMatrices{i} = fullExcludedIDsMatrix;
    fullDetectedSpikesIdxMatrices{i} = fullSpikesDetectedIdxMat;
    chosenMovies(i) = 0;%movieIdx;
    stableThresVectors{i} = stableThresVec;
    nOfSpikesDetected{i} = spikesDetectedVec;
    stabilityIslands{i} = neuronStabilityIslands;
%     plotMeasureForNeuronChoice(NEURON_ID, MOVIES, THRESHOLDS, ...
%         fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, ...
%         stableThresVec, spikesDetected, movieIdx, PATH_ROOT, COLOR_AXIS_LIM)
end
%%
artDict = containers.Map(NEURON_IDS, fullArtIdxMatrices);
spikeDict = containers.Map(NEURON_IDS, fullSpikeIdxMatrices);
excludedDict = containers.Map(NEURON_IDS, fullExcludedIdxMatrices);
detectedSpikesDict = containers.Map(NEURON_IDS, fullDetectedSpikesIdxMatrices);
thresDict = containers.Map(NEURON_IDS, stableThresVectors);
movieDict = containers.Map(NEURON_IDS, chosenMovies);
nOfSpikesDetDict = containers.Map(NEURON_IDS, nOfSpikesDetected);
stabilityIslandsDict = containers.Map(NEURON_IDS, stabilityIslands);
efficiencyMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
