function spikeCount = detectSpikesForMovie(traces, avgArtifact, threshold, sampleLim)
    artifactSubtracted = traces - repmat(avgArtifact, size(traces,1), 1);
    spikeDetected = zeros(size(traces,1),1);
    for i=1:length(spikesDetected)
        spikeDetected(i) = spikeDetector(artifactSubtracted(i), threshold, sampleLim);
    end
    spikeCount = sum(spikeDetected);
end 