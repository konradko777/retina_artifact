function spikeAmpDict = createNeuronSpikeAmpDict()
    global NEURON_IDS
    spikeAmps = zeros(size(NEURON_IDS));
    for i=1:length(NEURON_IDS)
        spikeAmps(i) = getSpikeAmp(NEURON_IDS(i));
    end
    spikeAmpDict = containers.Map(NEURON_IDS, spikeAmps);
end