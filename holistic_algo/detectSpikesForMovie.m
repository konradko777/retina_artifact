function [spikeCount, spikesDetected]  = detectSpikesForMovie(traces, avgArtifact, threshold, sampleLim)
    artifactSubtracted = traces - repmat(avgArtifact, size(traces,1), 1);
    spikesDetected = zeros(size(traces,1),1);
    for i=1:length(spikesDetected)
        spikesDetected(i) = spikeDetector(artifactSubtracted(i, :), threshold, sampleLim);
    end
    spikesDetected = logical(spikesDetected);
    spikeCount = sum(spikesDetected);
end 