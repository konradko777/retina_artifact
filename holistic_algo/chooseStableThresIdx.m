function stableThresholds = chooseStableThresIdx(stableClustersForMovies)
    nMovies = length(stableClustersForMovies);
    stableThresholds = zeros(nMovies, 1);
    for i = 1:nMovies
        cluster = stableClustersForMovies{i};
        if isempty(cluster)
            continue
        end
        stableThresholds(i) = cluster(end);
    end
    


end