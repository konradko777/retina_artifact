function spike = getEISpikeForNeuronEle(neuronID, electrode)
    ei = getEIForNeuron(neuronID);
    spike = ei(electrode + 1, :);
end