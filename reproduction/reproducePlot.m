function reproducePlot(patternNumber, movieNumber, quantThreshold, minArtifacts)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER
    electrodeNumber = patternNumber;
    tracesNumber = 50;
    offset = 11;
    path = 'C:\studia\dane_skrypty_wojtek\ks_functions\reproduction\';
    [DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(...
        DATA_PATH,DATA_PATH,0,patternNumber,movieNumber,TRACES_NUMBER_LIMIT,EVENT_NUMBER);
    electrodeData = squeeze(DataTraces(:, electrodeNumber, :));
    artifactIDs = mgrEstimateArtifactSignal_SIMPLE(electrodeData, ...
        quantThreshold, minArtifacts);
    electrodeData = electrodeData(:, 10:50);
    spikeIDs = setdiff(1:tracesNumber, artifactIDs);
    figure
    subplot(2,1,1)
    name = sprintf('Patterm%d-MovieNumber%d-QuantTh%d-MinArtifactsNoToEstimate%d', ...
        patternNumber,movieNumber, quantThreshold, minArtifacts);
    title(name);
    hold on
    plot(electrodeData', 'b');
    avgArtifact = plotAveragedArt(electrodeData, artifactIDs);
    legendHandle = legend('all traces', 'averaged artifact');
    correctLegend(legendHandle, [1 0 0]);
    subplot(2,1,2)
    plotArtifactSubstraction(avgArtifact, electrodeData, ...
        artifactIDs, spikeIDs);
    print([path name], '-dpng')
end
function correctLegend(legendHandle, color)
    children = get(legendHandle, 'children');
    children = flipud(children);
    set(children(5), 'color', color);

end
function avgArtifact = plotAveragedArt(traces, artifactIDs)
    avgArtifact = mean(traces(artifactIDs, :));
    plot(avgArtifact, 'r', 'linewidth', 2.5);
end

function plotArtifactSubstraction(avgArtifact, traces, artifactIDs, spikeIDs)
    artifacts = traces(artifactIDs, :);
    spikes = traces(spikeIDs, :);
    artSubtracted = artifacts - suitVectorToMatrix(avgArtifact, artifacts);
    spikesSubtracted = spikes - suitVectorToMatrix(avgArtifact, spikes);
    hold on
    plot(spikesSubtracted', 'g');
    plot(artSubtracted', 'r');
    legendHandle = legend('spikes - avg. artifact', 'artifacts - avg artifact', ...
        'location', 'southeast');
    correctLegend(legendHandle, [1 0 0]); 
end

function replicatedVec = suitVectorToMatrix(vector, matrix)
    [vnr, vnc] = size(vector);
    [mnr, mnc] = size(matrix);
    if vnr > vnc
        vector = vector';
    end
    replicatedVec = repmat(vector, mnr, 1);
end