function plotMeanClustAndAlgoSpikeForNeuron(meanClustSpike, meanAlgoSpike, neuronID)

    hold on
    plot(meanAlgoSpike, 'color', 'b')
    plot(meanClustSpike, 'color', 'r')

    ylim([-250 50])
    
    legend('algorithm spike', 'spike from clusterfile', 'location', 'southeast')
    title(num2str(neuronID))
end