function spikeDetected = spikeDetector(trace, threshold, sampleLim)
    spikeDetected = min(trace(sampleLim(1):sampleLim(2))) <= threshold;

end