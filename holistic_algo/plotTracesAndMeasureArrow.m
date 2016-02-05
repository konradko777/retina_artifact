function plotTracesAndMeasureArrow(neuronID, movie, thresholdArrowIdx, movieMeasureMat, ...
        algoMovieArtIDs, algoMovieExclIDs, algoMovieSpikeIDs, bestThreshold, ampThreshold, sampleLim, ...
        thresholdValues, path, colorLim, chosenMovie, yLimMin)
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
    notDetectedSpikesIdx = find(~detectedSpikesVec);
    bothSpikes = intersect(detectedSpikesIdx, clustSpikeIDs);
    bothArtifacts = intersect(notDetectedSpikesIdx, clustArtifactIDs);
    algoSpikesNotClust = setdiff(detectedSpikesIdx, clustSpikeIDs);
    algoArtifactsNotClust = setdiff(notDetectedSpikesIdx, clustArtifactIDs);
%     others = setdiff(1:nTraces, union(bothSpikes, bothArtifacts));
%     meanAlgoSpike = mean(traces(detectedSpikesVec, :));
    plotAllTraces(algoMovieThresArtIDs, algoMovieThresExclIDs, algoMovieThresSpikeIDs, ...
            bothSpikes, bothArtifacts, algoSpikesNotClust, algoArtifactsNotClust, traces, tracesMinusMeanArt,...
            movieMeasureMat, bestThreshold, thresholdValues, path, colorLim, chosenMovie, movie, detectedSpikesNo, ...
            neuronID, thresholdArrowIdx, algoMovieArtIDs, clustSpikesNo, recEle, yLimMin)
end


function plotAllTraces(algoMovieThresArtIDs, algoMovieThresExclIDs, algoMovieThresSpikeIDs, ...
            bothSpikes, bothArtifacts, algoSpikesNotClust, algoArtifactsNotClust, traces, tracesMinusMeanArt, ...
            movieMeasureMat, bestThreshold, thresholdValues, path, colorLim, chosenMovie, movie, detectedSpikesNo,...
            neuronID, thresholdArrowIdx, algoMovieArtIDs, clustSpikesNo, recEle, yLimMin)
    HORIZONTAL_OFFSET = .02;
    VERTICAL_OFFSET = .075;
    SMALL_WIDTH = .2;
    SMALL_HEIGHT = .4;
    BIG_WIDTH = .55;
    BIG_HEIGHT = 2*SMALL_HEIGHT + VERTICAL_OFFSET;
    Y_LIM = [yLimMin 50];
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    neuronStr = num2str(neuronID);
    movieStr = num2str(movie);
    thresStr = num2str(thresholdArrowIdx);
    
    subplot('Position', [HORIZONTAL_OFFSET, 2*VERTICAL_OFFSET + SMALL_HEIGHT, SMALL_WIDTH, SMALL_HEIGHT])
    hold on
    grid on
    set(gca, 'GridLineStyle', '-');
    title('Raw Signal', 'fontsize', 13)
    plotSelectedTraces(traces, algoMovieThresSpikeIDs,'g')
    plotSelectedTraces(traces, algoMovieThresArtIDs,'r')
    plotSelectedTraces(traces, algoMovieThresExclIDs,'k')
    legendHandle = legend('1st Step: not arts', '1st Step: arts ', '1st Step: excluded', ...
        'location', 'northeast');
    correctLegend(legendHandle, {'g', 'r', 'k'});

    subplot('Position', [2*HORIZONTAL_OFFSET + SMALL_WIDTH, 2*VERTICAL_OFFSET + SMALL_HEIGHT, SMALL_WIDTH, SMALL_HEIGHT])
    hold on
    grid on
    set(gca, 'GridLineStyle', '-');
    title('Raw Signal - mean artifact', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, algoMovieThresSpikeIDs,'g')
    plotSelectedTraces(tracesMinusMeanArt, algoMovieThresArtIDs,'r')
    plotSelectedTraces(tracesMinusMeanArt, algoMovieThresExclIDs,'k')
    legendHandle = legend('1st Step: not arts', '1st Step: arts ', '1st Step: excluded', ...
        'location', 'southeast');
    correctLegend(legendHandle, {'g', 'r', 'k'});
    ylim(Y_LIM)
    subplot('Position', [HORIZONTAL_OFFSET, VERTICAL_OFFSET, SMALL_WIDTH, SMALL_HEIGHT])
    hold on
    grid on
    set(gca, 'GridLineStyle', '-');
    title('Raw Signal', 'fontsize', 13)
    plotSelectedTraces(traces, bothSpikes,'g')
    plotSelectedTraces(traces, algoSpikesNotClust,'c')
    plotSelectedTraces(traces, bothArtifacts,'r')
    plotSelectedTraces(traces, algoArtifactsNotClust,'m')
    legendHandle = legend('2nd Step: both spikes', '2nd Step: algo not clust spikes ', '2nd Step: both arts', ...
        '2nd Step: algo not clust arts', 'location', 'northeast');
    correctLegend(legendHandle, {'g', 'c', 'r', 'm'});    
    
    
    subplot('Position', [2*HORIZONTAL_OFFSET + SMALL_WIDTH, VERTICAL_OFFSET, SMALL_WIDTH, SMALL_HEIGHT])
    hold on
    grid on
    set(gca, 'GridLineStyle', '-');
    title('Raw Signal - mean art', 'fontsize', 13)
    plotSelectedTraces(tracesMinusMeanArt, bothSpikes,'g')
    plotSelectedTraces(tracesMinusMeanArt, algoSpikesNotClust,'c')
    plotSelectedTraces(tracesMinusMeanArt, bothArtifacts,'r')
    plotSelectedTraces(tracesMinusMeanArt, algoArtifactsNotClust,'m')
    legendHandle = legend('2nd Step: both spikes', '2nd Step: algo not clust spikes ', '2nd Step: both arts', ...
        '2nd Step: algo not clust arts', 'location', 'southeast');
    correctLegend(legendHandle, {'g', 'c', 'r', 'm'});    
    ylim(Y_LIM)
    
    subplot('Position', [3*HORIZONTAL_OFFSET + 2*SMALL_WIDTH, VERTICAL_OFFSET, BIG_WIDTH, BIG_HEIGHT])
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
    axes('position',[0,0,1,1],'visible','off');
    text(.45, 0.99, sprintf('N: %d RecEle: %d, movie: %d', neuronID, recEle, movie), ...
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



