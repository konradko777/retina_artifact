function electrodes = findBestEleFromEIForNeurons(neurons)
    electrodes = zeros(size(neurons));
    i = 1;
    for neuron = neurons
        ei = getEIForNeuron(neuron);
        electrodes(i) = findBestEleFromEI(ei);
        i = i + 1;
    end
end