function thresholdDict = createDetectionThresFromSpikeAmp(spikeAmpDict)
    min_tolerance = -10;
    neuronIds = cell2mat(keys(spikeAmpDict));
    spikeAmps = cell2mat(values(spikeAmpDict));
    toleranceVals = zeros(size(neuronIds));
    i = 0;
    for neuron = neuronIds
        i = i + 1;
        spikeAmp = spikeAmpDict(neuron);
        percentTolerance = spikeAmp * .2;
        toleranceVals(i) = min(min_tolerance, percentTolerance);
    end
    thresholds = spikeAmps - toleranceVals;
    thresholdDict = containers.Map(neuronIds, thresholds);


end