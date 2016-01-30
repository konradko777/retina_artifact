function meanAlgoSpike = plotTracesAndMeasureArrow(neuronID, movie, thresholdArrowIdx, movieMeasureMat, ...
        algoMovieArtIDs, algoMovieExclIDs, algoMovieSpikeIDs, bestThreshold, ampThreshold, sampleLim, thresholdValues, path)
    global NEURON_REC_ELE_MAP
    global NEURON_CLUST_FILE_MAP NEURON_ELE_MAP
    
    algoMovieThresArtIDs = algoMovieArtIDs{thresholdArrowIdx};
    algoMovieThresExclIDs = algoMovieExclIDs{thresholdArrowIdx};
    algoMovieThresSpikeIDs = algoMovieSpikeIDs{thresholdArrowIdx};
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    recEle = NEURON_REC_ELE_MAP(neuronID);
    traces = getMovieEleTraces(movie, recEle);
    [clustSpikeIDs, clustArtifactIDs] = getSpikeArtIDs(clusterFileName,movie,patternNumber);
    clustSpikesNo = length(clustSpikeIDs);
    if length(algoMovieThresArtIDs) == 1
        meanAlgoArt = traces(algoMovieThresArtIDs, :);
    else
        meanAlgoArt = mean(traces(algoMovieThresArtIDs, :));
    end
    tracesMinusMeanArt = traces - repmat(meanAlgoArt,size(traces,1),1);
    [detectedSpikesNo, detectedSpikesVec] = detectSpikesForMovie(traces, meanAlgoArt, ampThreshold, sampleLim);
    meanAlgoSpike = mean(traces(detectedSpikesVec, :));
    
    
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 40 25])
    neuronStr = num2str(neuronID);
    movieStr = num2str(movie);
    thresStr = num2str(thresholdArrowIdx);
    subplot(2, 3, 1)
    hold on
    title('Raw Signal', 'fontsize', 13)
    plotSelectedTraces(traces,algoMovieThresSpikeIDs,'g')
    plotSelectedTraces(traces,algoMovieThresArtIDs,'r')
    plotSelectedTraces(traces,algoMovieThresExclIDs,'k')

    legendHandle = legend('Not artifacts by algorithm', 'Artifacts by algorithm', 'Excluded by algorithm');
    correctLegend(legendHandle, {'g', 'r', 'k'});
    subplot(2,3,2)
    hold on
    title('Raw Signal', 'fontsize', 13)
    plotSelectedTraces(traces, ~detectedSpikesVec, 'r')
    plotSelectedTraces(traces, detectedSpikesVec, 'g')
    legendHandle = legend('Others by spike detector', 'Spikes by spike detector');
    correctLegend(legendHandle, {'r', 'g'});
    subplot(2, 3, 3)
    
    plotMeasureForNeuronMovieArrow(movieMeasureMat, thresholdValues, ...
        algoMovieArtIDs, clustSpikesNo, [0 30], 1, ...
        bestThreshold, 1, detectedSpikesNo, thresholdArrowIdx)
    %artifactIDsMatrix - in each cell vector of artifact IDs for given
    %clusterArtifactNo(int) - number of artifact taken from cluster file
    %caxisLim([min(int) max(int)]) - min and max value used while color mapping
    %selectedMovie(int) - amplitude chosen by algo
    %markSelectedMovie(bool) - whether to show on plot, which movie was
    %   chosen
    %selectedThresholds(array<ints> - indices of selected thresholds
    %markselectedThresholds - whether to mark selected thersholds
    %movie

    
    subplot(2,3,4)
    hold on
    title('Raw Signal - mean artifact by algorithm', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, algoMovieThresArtIDs, 'r')
    plotSelectedTraces(tracesMinusMeanArt, algoMovieThresExclIDs,'k')
    plotSelectedTraces(tracesMinusMeanArt, algoMovieThresSpikeIDs, 'g')
    legendHandle = legend('Artifacts by algorithm','Excluded by algorthm', 'Others by algorithm');
    correctLegend(legendHandle, {'r', 'k', 'g'});
    subplot(2,3,5)
    hold on
    title('Raw Signal - mean artifact by algorithm', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, ~detectedSpikesVec, 'r')
    plotSelectedTraces(tracesMinusMeanArt, detectedSpikesVec, 'g')
    legendHandle = legend('Others by spike detector', 'Spikes by spike detector');
    correctLegend(legendHandle, {'r', 'g'});
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.97, sprintf('Neuron: %d Recording ele: %d', neuronID, recEle), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    print([path neuronStr '_' movieStr '_' thresStr '_mean_spike'], '-dpng', '-r300');
    close(f)
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



