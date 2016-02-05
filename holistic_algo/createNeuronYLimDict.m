function yLimDict= createNeuronYLimDict()
    yLimDict= createYLimDictByHand();
end

function dict_ = createYLimDictByHand()
%% change asap! automate it!
    NEURON_IDS=[76 227 256 271 391 406 541 616 691 736 856 901];
    yLimByHand = [-80 -120 -80 -170 -90 -140 -150 -150 -100 -300 -70 -175];
    dict_ = containers.Map(NEURON_IDS, yLimByHand);
    %736 - -300
end

% function spikeAmpDict = createAmpDictByHand2()
%     global NEURON_IDS
%     spikeAmps = zeros(size(NEURON_IDS));
%     for i=1:length(NEURON_IDS)
%         spikeAmps(i) = -30;
%     end
%     spikeAmpDict = containers.Map(NEURON_IDS, spikeAmps);
% 
% end