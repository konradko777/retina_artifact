function meanAlgoSpike = checkAlgorithmOutcome(neuronID, movie, algoMovieArtIDs, algoMovieExclIDs, algoMovieSpikeIDs, threshold, sampleLim)
    global NEURON_REC_ELE_MAP
    global NEURON_CLUST_FILE_MAP NEURON_ELE_MAP
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    recEle = NEURON_REC_ELE_MAP(neuronID);
    traces = getMovieEleTraces(movie, recEle);
    [clustSpikeIDs, clustArtifactIDs] = getSpikeArtIDs(clusterFileName,movie,patternNumber);
    meanAlgoArt = mean(traces(algoMovieArtIDs, :));
    tracesMinusMeanArt = traces - repmat(meanAlgoArt,size(traces,1),1);
    [~, detectedSpikesVec] = detectSpikesForMovie(traces, meanAlgoArt, threshold, sampleLim);
    meanAlgoSpike = mean(traces(detectedSpikesVec, :));
    subplot(4, 1, 1)
    hold on
    title('Raw Signal', 'fontsize', 13)
    plotSelectedTraces(traces,algoMovieArtIDs,'r')
    plotSelectedTraces(traces,algoMovieExclIDs,'k')
    plotSelectedTraces(traces,algoMovieSpikeIDs,'g')
    legendHandle = legend('Artifacts by algorithm', 'Excluded by algorithm',...
        'Others by algorithm');
    correctLegend(legendHandle, {'r', 'k', 'g'});
    subplot(4,1,2)
    hold on
    title('Raw Signal - mean artifact by algorithm', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, algoMovieArtIDs, 'r')
    plotSelectedTraces(tracesMinusMeanArt, algoMovieSpikeIDs, 'g')
    legendHandle = legend('Artifacts by algorithm', 'Others by algorithm');
    correctLegend(legendHandle, {'r', 'g'});
    subplot(4,1,3)
    hold on
    title('Raw Signal - mean artifact by algorithm', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, ~detectedSpikesVec, 'r')
    plotSelectedTraces(tracesMinusMeanArt, detectedSpikesVec, 'g')
    legendHandle = legend('Others by spike detector', 'Spikes by spike detector');
    correctLegend(legendHandle, {'r', 'g'});
    subplot(4,1,4)
    hold on
    title('Raw Signal - mean artifact by algorithm', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, clustArtifactIDs, 'r')
    plotSelectedTraces(tracesMinusMeanArt, clustSpikeIDs, 'g')
    legendHandle = legend('Arifacts by clustering', 'Spikes by clustering');
    correctLegend(legendHandle, {'r', 'g'});
    %rewrite spike detector to return logic vector as well
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.97, sprintf('Neuron: %d Recording ele: %d', neuronID, recEle), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
end

function [spikeIDs , artifactIDs]= getSpikeArtIDs(clusterFileName,movieNumber,patternNumber)
    WaveformTypes=NS_ReadClusterFile(clusterFileName,movieNumber,patternNumber,50); %1 artefakt 2spike
    spikeIDs = find(WaveformTypes == 2);
    artifactIDs = find(WaveformTypes == 1);
end

function correctLegend(legendHandle, colors)
    children = get(legendHandle, 'children');
    children = flipud(children);
    for i = 1:(length(colors))
        color = colors{i};
        set(children(2 + (i-1) * 3), 'color', color);
    end
end



