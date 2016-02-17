SAMPLES_LIM = [11 40];
MOVIES = [1, 3, 5, 7];%1:24;
THRESHOLDS = 10:5:100;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
SPIKE_DET_MARG = 30;
HOW_MANY_SPIKES = 25;
PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\512\';
addJava
setGlobals512
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 30);
global NEURON_SPIKE_AMP_MAP
AMP_DICT = NEURON_SPIKE_AMP_MAP;
COLOR_AXIS_LIM = [0 300];
global NEURON_IDS
fullArtIdxMatrices = cell(size(NEURON_IDS));
fullSpikeIdxMatrices = cell(size(NEURON_IDS));
fullExcludedIdxMatrices = cell(size(NEURON_IDS));
fullDetectedSpikesIdxMatrices = cell(size(NEURON_IDS));
stableThresVectors = cell(size(NEURON_IDS));
chosenMovies = zeros(size(NEURON_IDS));
for i = 1%:length(NEURON_IDS);
    NEURON_ID = NEURON_IDS(i);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, ...
        fullClustArtNumVec, stableThresVec, spikesDetectedVec, fullSpikesDetectedIdxMat, movieIdx] = ...
        holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle, thresBreach20, MINIMAL_CLUSTER, SPIKE_DET_MARG, HOW_MANY_SPIKES);
    fullArtIdxMatrices{i} = fullArtifactIDsMatrix;
    fullSpikeIdxMatrices{i} = fullSpikesIDsMatrix;
    fullExcludedIdxMatrices{i} = fullExcludedIDsMatrix;
    fullDetectedSpikesIdxMatrices{i} = fullSpikesDetectedIdxMat;
    chosenMovies(i) = 0;%movieIdx;
    stableThresVectors{i} = stableThresVec;
%     plotMeasureForNeuronChoice(NEURON_ID, MOVIES, THRESHOLDS, ...
%         fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, ...
%         stableThresVec, spikesDetected, movieIdx, PATH_ROOT, COLOR_AXIS_LIM)
end

artDict = containers.Map(NEURON_IDS, fullArtIdxMatrices);
spikeDict = containers.Map(NEURON_IDS, fullSpikeIdxMatrices);
excludedDict = containers.Map(NEURON_IDS, fullExcludedIdxMatrices);
detectedSpikesDict = containers.Map(NEURON_IDS, fullDetectedSpikesIdxMatrices);
thresDict = containers.Map(NEURON_IDS, stableThresVectors);
movieDict = containers.Map(NEURON_IDS, chosenMovies);

path = 'C:\studia\dane_skrypty_wojtek\ks_functions\512\graph\';
for NEURON_ID = 3245%NEURON_IDS
    allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
    allTracesSubtracted = subtractMeanArtFromMovies(allTraces, artDict(NEURON_ID), thresDict(NEURON_ID), MOVIES);
    nOfSpikesVec = getNOfSpikesForMovies(MOVIES, detectedSpikesDict(NEURON_ID));
%     [minMovie, maxMovie] = getApplicabilityRangeSpikes(nOfSpikesVec);
    minMovie = 1;
    maxMovie = 4;
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    plotAppTracesForNeuronSpike(NEURON_ID, detectedSpikesDict(NEURON_ID), artDict(NEURON_ID), ...
        spikeDict(NEURON_ID), thresDict(NEURON_ID), allTracesSubtracted, MOVIES, minMovie, maxMovie, movieDict(NEURON_ID), THRESHOLDS)
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.99, sprintf('Traces and applicability range for neuron: %d', NEURON_ID), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    neuronStr = num2str(NEURON_ID);
    print([path neuronStr '_range'], '-dpng', '-r150');
    close(f)
end
