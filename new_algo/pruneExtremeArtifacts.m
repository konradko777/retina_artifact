function prunedIDs = pruneExtremeArtifacts(waveforms, artifactIDs, nToExclude, samplesLim)
    cutArtWaveforms = waveforms(artifactIDs, samplesLim(1):samplesLim(2));
    avgArtifact = mean(cutArtWaveforms);
    errors = cutArtWaveforms - repmat(avgArtifact, size(cutArtWaveforms, 1), 1);
    [~, indices] = sort(sum(abs(errors), 2), 'descend');
    sortedArtIDs = artifactIDs(indices);
    prunedIDs = sortedArtIDs(1:nToExclude);
end