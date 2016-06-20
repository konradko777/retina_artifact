
addJava
setGlobals512_03
load 512_03_all_vars
%%
% NEURON_IDS = NEURON_IDS(1:2);
allTraces = zeros(length(NEURON_IDS) * 32, 50, 140);
classification = zeros(length(NEURON_IDS), 50);
for i = 1:length(NEURON_IDS)
    for j = 1:32
        allTraces((i - 1) * 32 + j, :, :) = getTracesForNeuronMovie(NEURON_IDS(i), j*2 - 1);
        stableThres = thresDict(NEURON_IDS(i));
        stableThres = stableThres(j);
        artIDs = artDict(NEURON_IDS(i));
        artIDs = artIDs{j};
        classification((i - 1) * 32 + j, artIDs{stableThres}) = 1;
    end
end

%%
hold on
occurance = 1557;
plot(squeeze(allTraces(occurance, :, :))', 'k')
plot(squeeze(allTraces(occurance, logical(classification(occurance, :)), :))', 'r')