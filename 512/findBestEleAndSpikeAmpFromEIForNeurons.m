function [electrodes, spikeAmps]= findBestEleAndSpikeAmpFromEIForNeurons(neurons)
%returns the the spikeAmplitude(the most negative sample in ei) and
%   electrode associated with it
    electrodes = zeros(size(neurons));
    spikeAmps = zeros(size(neurons));
    i = 1;
    for neuron = neurons
        ei = getEIForNeuron(neuron);
        electrodes(i) = findBestEleFromEI(neuron, ei);
        spikeAmps(i) = findSpikeAmpFromEI(electrodes(i), ei); %dopisac
        i = i + 1;
    end
end