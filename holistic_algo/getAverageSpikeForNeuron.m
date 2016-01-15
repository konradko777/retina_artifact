function avgSpike = getAverageSpikeForNeuron(neuronID)
    [spikeTraces, artTraces] = getSpikeArtTracesForNeuron(neuronID);
    avgSpikePlusArt = mean(spikeTraces);
    avgArt = mean(artTraces);
    avgSpike = avgSpikePlusArt - avgArt;
end