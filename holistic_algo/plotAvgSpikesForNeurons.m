function plotAvgSpikesForNeurons()
    global NEURON_IDS
    figure
    for i=1:12
        neuronID = NEURON_IDS(i);
        subplot(3,4,i)
        title(num2str(neuronID))
        plotAverageSpikeForNeuron(neuronID)
    end
        
end

