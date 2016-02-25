SAMPLES_LIM = [8 37];
MOVIES = 1:2:63;
THRESHOLDS = 10:5:100;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
SPIKE_DET_MARG = 30;
HOW_MANY_SPIKES = 25;
PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\512\';
addJava
setGlobals512
global NEURON_ELE_MAP NEURON_REC_ELE_MAP NEURON_SPIKE_AMP_MAP NEURON_IDS ELE_MAP_OBJ
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 30);
SPIKE_DETECTION_THRES_DICT = createDetectionThresFromSpikeAmp(NEURON_SPIKE_AMP_MAP);
COLOR_AXIS_LIM = [0 300];
N_OF_TRACES = 50;


NEURON_ID = NEURON_IDS(1);
stimEle = NEURON_ELE_MAP(NEURON_ID);
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
adjacentElectrodes = getAdjacentElectrodes(recEle, ELE_MAP_OBJ);
eleRelativePositionDict = createPositionDictForAdjEles(recEle, ELE_MAP_OBJ);

resultStructs = {};
i = 1;
for currentStimEle = adjacentElectrodes'
    currentStimEle
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, ...
        fullClustArtNumVec, stableThresVec, spikesDetectedVec, fullSpikesDetectedIdxMat, movieIdx] = ...
        holisticAlgo512(MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle,...
        thresBreach20, MINIMAL_CLUSTER, HOW_MANY_SPIKES, SPIKE_DETECTION_THRES_DICT(NEURON_ID), recEle, currentStimEle);
    result.bestMovieIdx = findBestMovie(spikesDetectedVec);
    if result.bestMovieIdx > 0
        result.stableThresIdx = stableThresVec(bestMovieIdx);
        result.firstStepArt= fullArtifactIDsMatrix{result.bestMovieIdx}{result.stableThresIdx};
        result.firstStepSpikes = fullSpikesIDsMatrix{result.bestMovieIdx}{result.stableThresIdx};
        result.secondStepSpikes = fullSpikesDetectedIdxMat{result.bestMovieIdx};
        result.secondStepArts = setdiff(1:N_OF_TRACES, result.secondStepSpikes);
        result.bestMovieTraces = getMovieElePatternTraces(MOVIES(result.bestMovieIdx), recEle, currentStimEle);
        result.subtractedTraces = subtractMeanArtFromMovieTraces(result.bestMovieTraces, result.firstStepArt);
    end
    resultStructs{i} = result;
    clear result;
    i = i + 1;
end
% resultStructsDict = containers.Map(adjacentElectrodes, resultStructs);
plotHexagonally(adjacentElectrodes, resultStructs)
% result.traces = getMovieEleTraces(MOVIES(result.bestMovieIdx), 
% fullArtIdxMatrices{i} = fullArtifactIDsMatrix;
% fullSpikeIdxMatrices{i} = fullSpikesIDsMatrix;
% fullExcludedIdxMatrices{i} = fullExcludedIDsMatrix;
% fullDetectedSpikesIdxMatrices{i} = fullSpikesDetectedIdxMat;
% chosenMovies(i) = 0;%movieIdx;
% stableThresVectors{i} = stableThresVec;
% nOfSpikesDetected{i} = spikesDetectedVec;