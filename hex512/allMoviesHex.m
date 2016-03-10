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


for NEURON_ID = 110%NEURON_IDS(11:70)
    recEle = NEURON_REC_ELE_MAP(NEURON_ID);
    stimEle = NEURON_ELE_MAP(NEURON_ID);
    eiSpike = getEISpikeForNeuronEle(NEURON_ID, NEURON_REC_ELE_MAP(NEURON_ID));
    eiSpikeAmp = NEURON_SPIKE_AMP_MAP(NEURON_ID);
    detectionThres = SPIKE_DETECTION_THRES_DICT(NEURON_ID);
    adjacentElectrodes = getAdjacentElectrodes(recEle, ELE_MAP_OBJ);
    eleRelativePositionDict = createPositionDictForAdjEles(recEle, ELE_MAP_OBJ);
    allMoviesResultStructs = cell(length(MOVIES), length(adjacentElectrodes));
    i = 1;
    for currentStimEle = adjacentElectrodes'
        [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, ...
            fullClustArtNumVec, stableThresVec, spikesDetectedVec, fullSpikesDetectedIdxMat, bestMovieIdx] = ...
            holisticAlgo512(MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle,...
            thresBreach20, MINIMAL_CLUSTER, HOW_MANY_SPIKES, SPIKE_DETECTION_THRES_DICT(NEURON_ID), recEle, currentStimEle);
        for movieIDX = 1:length(MOVIES)
            result.bestMovieIdx = movieIDX;
            result.stableThresIdx = stableThresVec(result.bestMovieIdx);
            result.firstStepArt= fullArtifactIDsMatrix{result.bestMovieIdx}{result.stableThresIdx};
            result.firstStepSpikes = fullSpikesIDsMatrix{result.bestMovieIdx}{result.stableThresIdx};
            result.secondStepSpikes = fullSpikesDetectedIdxMat{result.bestMovieIdx};
            result.secondStepArts = setdiff(1:N_OF_TRACES, result.secondStepSpikes);
            result.bestMovieTraces = getMovieElePatternTraces(MOVIES(result.bestMovieIdx), recEle, currentStimEle);
            result.subtractedTraces = subtractMeanArtFromMovieTraces(result.bestMovieTraces, result.firstStepArt);
            result.spikesDetected = spikesDetectedVec(result.bestMovieIdx);
            allMoviesResultStructs{movieIDX, i} = result;
            clear result;
        end
        i = i + 1;
    end
end

for movieIdx = 1:size(allMoviesResultStructs,1)
    resultStructs = allMoviesResultStructs(movieIdx, :);
    path = ['C:\studia\dane_skrypty_wojtek\ks_functions\hex512\hex_all_movies\' num2str(NEURON_ID) '\'];
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    plotHexagonally(adjacentElectrodes, resultStructs, eiSpike, eiSpikeAmp, detectionThres, stimEle)
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.99, sprintf('Neuron: %d', NEURON_ID), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    neuronStr = num2str(NEURON_ID);
    print([path neuronStr '_' num2str(movieIdx)], '-dpng', '-r150');
    close(f)
end