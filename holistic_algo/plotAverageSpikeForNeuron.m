function plotAverageSpikeForNeuron(neuronID)
    [spikeTraces, artTraces] = getSpikeArtTracesForNeuron(neuronID);
    avgSpikePlusArt = mean(spikeTraces);
    avgArt = mean(artTraces);
    plot(avgSpikePlusArt - avgArt)
    title(num2str(neuronID));
end