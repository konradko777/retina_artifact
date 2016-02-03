function meanAlgoSpike = plotTracesAndMeasureArrow(neuronID, movie, thresholdArrowIdx, movieMeasureMat, ...
        algoMovieArtIDs, algoMovieExclIDs, algoMovieSpikeIDs, bestThreshold, ampThreshold, sampleLim, ...
        thresholdValues, path, colorLim, chosenMovie)
    global NEURON_REC_ELE_MAP
    global NEURON_CLUST_FILE_MAP NEURON_ELE_MAP
    algoMovieThresArtIDs = algoMovieArtIDs{thresholdArrowIdx};
    algoMovieThresExclIDs = algoMovieExclIDs{thresholdArrowIdx};
    algoMovieThresSpikeIDs = algoMovieSpikeIDs{thresholdArrowIdx};
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    recEle = NEURON_REC_ELE_MAP(neuronID);
    traces = getMovieEleTraces(movie, recEle);
    nTraces = size(traces, 1);
    [clustSpikeIDs, clustArtifactIDs] = getSpikeArtIDs(clusterFileName,movie,patternNumber);
    clustSpikesNo = length(clustSpikeIDs);
    if length(algoMovieThresArtIDs) == 1
        meanAlgoArt = traces(algoMovieThresArtIDs, :);
    else
        meanAlgoArt = mean(traces(algoMovieThresArtIDs, :));
    end
    tracesMinusMeanArt = traces - repmat(meanAlgoArt,size(traces,1),1);
    [detectedSpikesNo, detectedSpikesVec] = detectSpikesForMovie(traces, meanAlgoArt, ampThreshold, sampleLim);
    detectedSpikesIdx = find(detectedSpikesVec);
    bothSpikes = intersect(detectedSpikesIdx, clustSpikeIDs);
    bothArtifacts = intersect(algoMovieThresArtIDs, clustArtifactIDs);
    algoSpikesNotClust = reshape(setdiff(detectedSpikesIdx, clustSpikeIDs), [], 1);
    algoArtifactsNotClust = reshape(setdiff(algoMovieThresArtIDs, clustArtifactIDs), [], 1);
    others = setdiff(1:nTraces, [bothSpikes; bothArtifacts; algoSpikesNotClust; algoArtifactsNotClust;]);
    meanAlgoSpike = mean(traces(detectedSpikesVec, :));
    
    
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    neuronStr = num2str(neuronID);
    movieStr = num2str(movie);
    thresStr = num2str(thresholdArrowIdx);
    
    subplot(2, 3, 1)
    hold on
    grid on
    set(gca, 'GridLineStyle', '-');
    title('Raw Signal', 'fontsize', 13)
    plotSelectedTraces(traces, bothSpikes,'g')
    plotSelectedTraces(traces, algoSpikesNotClust,'c')
    plotSelectedTraces(traces, bothArtifacts,'r')
    plotSelectedTraces(traces, algoArtifactsNotClust,'m')
    plotSelectedTraces(traces, others,'k')
    legendHandle = legend('Both Spikes', 'onlyAlgoSpikes', 'Both Artifact', 'onlyAlgoArtifacts', 'Others', ...
        'location', 'southeast');
    correctLegend(legendHandle, {'g','c', 'r', 'm' 'k'});
    subplot(2,3,4)
    hold on
    grid on
    set(gca, 'GridLineStyle', '-');
    title('Raw Signal - mean artifact', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, bothSpikes,'g')
    plotSelectedTraces(tracesMinusMeanArt, algoSpikesNotClust,'c')
    plotSelectedTraces(tracesMinusMeanArt, bothArtifacts,'r')
    plotSelectedTraces(tracesMinusMeanArt, algoArtifactsNotClust,'m')
    plotSelectedTraces(tracesMinusMeanArt, others,'k')
    legendHandle = legend('Both Spikes', 'onlyAlgoSpikes', 'Both Artifact', 'onlyAlgoArtifacts', 'Others', ...
        'location', 'southeast');
    correctLegend(legendHandle, {'g','c', 'r', 'm' 'k'});
    subplot(2, 3, [2, 3, 5, 6])
    if movie == chosenMovie
        plotMeasureForNeuronMovieArrow(movieMeasureMat, thresholdValues, ...
            algoMovieArtIDs, clustSpikesNo, colorLim, 1, ...
            bestThreshold, 1, detectedSpikesNo, thresholdArrowIdx)
    
    else
        plotMeasureForNeuronMovieArrow(movieMeasureMat, thresholdValues, ...
            algoMovieArtIDs, clustSpikesNo, colorLim, 0, ...
            bestThreshold, 1, detectedSpikesNo, thresholdArrowIdx)
    end
    colorbar
    %artifactIDsMatrix - in each cell vector of artifact IDs for given
    %clusterArtifactNo(int) - number of artifact taken from cluster file
    %caxisLim([min(int) max(int)]) - min and max value used while color mapping
    %selectedMovie(int) - amplitude chosen by algo
    %markSelectedMovie(bool) - whether to show on plot, which movie was
    %   chosen
    %selectedThresholds(array<ints> - indices of selected thresholds
    %markselectedThresholds - whether to mark selected thersholds
    %movie

    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.97, sprintf('Neuron: %d Recording ele: %d', neuronID, recEle), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    print([path neuronStr '_' movieStr '_' thresStr '_mean_spike'], '-dpng', '-r150');
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



