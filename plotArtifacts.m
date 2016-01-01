function plotArtifacts(electrode, pattern, movie, QuantTh, MinArtifactsNoToEstimate)
    data = read_data(electrode, pattern, movie);
    active_vec = ones(size(data,1));
    artifact_ids = mgrEstimateArtifactSignal(data, active_vec, QuantTh, ...
        MinArtifactsNoToEstimate);
    spike_ids = setdiff(1:length(active_vec), artifact_ids);
    figure
    subplot(211)
    plot(data(artifact_ids, :)')
    title('Artifacts')
    subplot(212)
    plot(data(spike_ids, :)')
    title('Spikes')
end

function data1channel = read_data(electrode, pattern, movie)
    DataPath = 'data003';
    TracesNumberLimit=50;
    EventNumber=0;
    [DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(DataPath,...
        DataPath,0,pattern,movie,TracesNumberLimit,EventNumber);
    data1channel = squeeze(DataTraces(:, electrode, :));
end