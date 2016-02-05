function spikeAmpDict = createNeuronSpikeAmpDict()
    spikeAmpDict = createAmpDictByHand();
end


% function spikeAmpDict = createNeuronSpikeAmpDict()
%     global NEURON_IDS
%     spikeAmps = zeros(size(NEURON_IDS));
%     for i=1:length(NEURON_IDS)
%         spikeAmps(i) = getSpikeAmp(NEURON_IDS(i));
%     end
%     spikeAmpDict = containers.Map(NEURON_IDS, spikeAmps);
% end

function dict_ = createAmpDictByHand()
%% change asap! automate it!
    NEURON_IDS=[76 227 256 271 391 406 541 616 691 736 856 901];
    spikeHandAmps = [-20 -80 -20 -50 -50 -40 -50 -70 -40 -100 -30 -50];
    dict_ = containers.Map(NEURON_IDS, spikeHandAmps);

end

function spikeAmpDict = createAmpDictByHand2()
    global NEURON_IDS
    spikeAmps = zeros(size(NEURON_IDS));
    for i=1:length(NEURON_IDS)
        spikeAmps(i) = -30;
    end
    spikeAmpDict = containers.Map(NEURON_IDS, spikeAmps);

end