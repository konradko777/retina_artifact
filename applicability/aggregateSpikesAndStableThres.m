setGlobalsForApp
global NEURON_IDS
fullArtIdxMatrices = cell(size(NEURON_IDS));
fullSpikeIdxMatrices = cell(size(NEURON_IDS));
fullExcludedIdxMatrices = cell(size(NEURON_IDS));
fullDetectedSpikesIdxMatrices = cell(size(NEURON_IDS));
stableThresVectors = cell(size(NEURON_IDS));
chosenMovies = zeros(size(NEURON_IDS));
for i = 1:length(NEURON_IDS);
    NEURON_ID = NEURON_IDS(i);
    [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, ...
        fullClustArtNumVec, stableThresVec, spikesDetectedVec, fullSpikesDetectedIdxMat, movieIdx] = ...
        holisticAlgo1(NEURON_ID, MOVIES, THRESHOLDS, SAMPLES_LIM, algoHandle, measureHandle, thresBreach20, MINIMAL_CLUSTER, SPIKE_DET_MARG, HOW_MANY_SPIKES);
    fullArtIdxMatrices{i} = fullArtifactIDsMatrix;
    fullSpikeIdxMatrices{i} = fullSpikesIDsMatrix;
    fullExcludedIdxMatrices{i} = fullExcludedIDsMatrix;
    fullDetectedSpikesIdxMatrices{i} = fullSpikesDetectedIdxMat;
    chosenMovies(i) = movieIdx;
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
% 
% traces = getTracesForNeuronMovie(76, 7);
% hold on
% plot(traces')
% [spikesDetectedVec, spikesDetectedIdxMat] = detectSpikesForNeuron(76, 7, artDict(76), thresDict(76), 0, SAMPLES_LIM);
% plotSelectedTraces(traces, spikesDetectedIdxMat{1}, 'g')
% % traces = spi



path = 'C:\studia\dane_skrypty_wojtek\ks_functions\applicability\graph\';
for NEURON_ID = NEURON_IDS
    allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
    allTracesSubtracted = subtractMeanArtFromMovies(allTraces, artDict(NEURON_ID), thresDict(NEURON_ID), MOVIES);
    nOfSpikesVec = getNOfSpikesForMovies(MOVIES, detectedSpikesDict(NEURON_ID));
    [minMovie, maxMovie] = getApplicabilityRangeSpikes(nOfSpikesVec);
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    plotAppTracesForNeuronSpike(NEURON_ID, detectedSpikesDict(NEURON_ID), allTraces, MOVIES, minMovie, maxMovie, movieDict(NEURON_ID))
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.99, sprintf('Traces and applicability range for neuron: %d', NEURON_ID), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    neuronStr = num2str(NEURON_ID);
    print([path neuronStr '_range'], '-dpng', '-r150');
    close(f)
end


i = 1;
for NEURON_ID = NEURON_IDS
    nOfSpikeVec = getNOfSpikesForMovies(MOVIES, detectedSpikesDict(NEURON_ID));
    subplot(3,4,i)
    plotArtFoundForNeuron(nOfSpikeVec, movieDict(NEURON_ID), NEURON_ID, 0, 0)
    [minMovie, maxMovie] = getApplicabilityRangeSpikes(nOfSpikeVec);
    plotArtFoundForNeuron(nOfSpikeVec, movieDict(NEURON_ID), NEURON_ID, minMovie, maxMovie)
    i = i + 1;
end
% axes('position',[0,0,1,1],'visible','off');
% text(.5, 0.99, sprintf('Applicability range for neurons. Spike detection.'), ...
%     'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')