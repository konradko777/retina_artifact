function stableThresholdsMat = getMinStableThresForMovies(fullMeasureMat, movies, thresholds, breachFunction, minimalCluster)
    nMovies = length(movies);
    stableThresholdsMat = cell(nMovies,1);
    for i = 1:nMovies
        measureMat = squeeze(fullMeasureMat(i,:,:));
        stableThresForMovie = getMinimalStableThresholds(measureMat, thresholds, breachFunction, minimalCluster);
        stableThresholdsMat{i} = stableThresForMovie;
    end
end