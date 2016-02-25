function avgArtifact = getAvgArtifactFromAlgo(traces, artifactIDs)
    if length(artifactIDs) == 1
        avgArtifact = traces(artifactIDs, :);
    else
        avgArtifact = mean(traces(artifactIDs, :));
    end
end