function spikeAmp = getSpikeAmp(neuronID)
    avgSpike = getAverageSpikeForNeuron(neuronID);
    spikeAmp = min(avgSpike);
end