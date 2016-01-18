function avgArtifact = getAvgArtifactFromAlgo(traces, artifactIDs)
    avgArtifact = mean(traces(artifactIDs, :));

end