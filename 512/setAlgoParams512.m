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
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 30);
global NEURON_SPIKE_AMP_MAP
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
for i = 1:length(NEURON_IDS);
    i
    NEURON_ID = NEURON_IDS(i);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, ...
        fullClustArtNumVec, stableThresVec, spikesDetectedVec, fullSpikesDetectedIdxMat, movieIdx] = ...
        holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle,...
        thresBreach20, MINIMAL_CLUSTER, HOW_MANY_SPIKES, SPIKE_DETECTION_THRES_DICT(NEURON_ID));
    fullArtIdxMatrices{i} = fullArtifactIDsMatrix;
    fullSpikeIdxMatrices{i} = fullSpikesIDsMatrix;
    fullExcludedIdxMatrices{i} = fullExcludedIDsMatrix;
    fullDetectedSpikesIdxMatrices{i} = fullSpikesDetectedIdxMat;
    chosenMovies(i) = 0;%movieIdx;
    stableThresVectors{i} = stableThresVec;
    nOfSpikesDetected{i} = spikesDetectedVec;
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
nOfSpikesDetDict = containers.Map(NEURON_IDS, nOfSpikesDetected);

path = 'C:\studia\dane_skrypty_wojtek\ks_functions\512\graph\';
for NEURON_ID = NEURON_IDS(1:70)
    allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
    nOfSpikesVec = nOfSpikesDetDict(NEURON_ID);
    allTracesSubtracted = subtractMeanArtFromMovies(allTraces, artDict(NEURON_ID), thresDict(NEURON_ID), MOVIES, nOfSpikesVec);
    [minMovie, maxMovie] = getApplicabilityRangeSpikes512(nOfSpikesVec);
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    plotAppTracesForNeuronSpike512(NEURON_ID, detectedSpikesDict(NEURON_ID), artDict(NEURON_ID), ...
        spikeDict(NEURON_ID), thresDict(NEURON_ID), allTraces, MOVIES, minMovie, maxMovie, movieDict(NEURON_ID), THRESHOLDS, nOfSpikesVec)
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.99, sprintf('Traces and applicability range for neuron: %d', NEURON_ID), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    neuronStr = num2str(NEURON_ID);
    print([path neuronStr '_range'], '-dpng', '-r150');
    close(f)
end

for NEURON_ID = NEURON_IDS
    f = figure();
    nOfSpikesVec = nOfSpikesDetDict(NEURON_ID);
    [minIdx, maxIdx] = getApplicabilityRangeSpikes512(nOfSpikesVec);
    hold on
    plot(nOfSpikesVec)
    ylim([-5 50])
    line([minIdx minIdx], ylim, 'color', 'g')
    line([maxIdx maxIdx], ylim, 'color', 'g')
    neuronStr = num2str(NEURON_ID);
    title(neuronStr);
    print([path neuronStr '_det_spikes'], '-dpng', '-r150');
    close(f)
end
