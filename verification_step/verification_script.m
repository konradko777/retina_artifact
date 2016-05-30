addJava
setGlobals512_00
load 512_00_with_islands
%%
neuronSpikeArtVerified = zeros(length(NEURON_IDS), 3);
for i = 1:length(NEURON_IDS)
    neuron = NEURON_IDS(i);
    spikeVec = nOfSpikesDetDict(neuron);
    spikeVerified = mapSFVecTo100PercMovieIdx(spikeVec);
    stabilityIslandsForNeuron = stabilityIslandsDict(neuron);
    stabIslSizeVec = getStabIslSizesForNeuron(stabilityIslandsForNeuron);
    nOfArtsFound = getArtNoForLastIslThres(artDict(neuron), stabilityIslandsForNeuron);
    artVerified = mapArtVecTo100PercMovieIdx(nOfArtsFound, 32);
    neuronSpikeArtVerified(i, :) = [neuron spikeVerified artVerified];
    firstIndices = getFirstThresIdxForMovies(stabilityIslandsForNeuron);
    positions = generatePositionDict3(6, 10, .02, .04);
    subplot('Position', positions{i})
    hold on
    title(num2str(neuron))
    plot(spikeVec)
    plot(nOfArtsFound, 'g.-')
%     plot(stabIslSizeVec, 'r')
%     plot(firstIndices, 'm')
%     legend('spikeDetection', 'art found for last', 'island size', 'idx of first thres')
end
neuronSpikeArtVerified

figure
hist(neuronSpikeArtVerified(:, 3) - neuronSpikeArtVerified(:, 2), 40)

%% avg art and  avg non art dissim
for i = 1:length(NEURON_IDS)
    neuron = NEURON_IDS(i);
    if any([4642 1583 1146 217] == neuron)
        continue
    end
    neuronTraces = getTracesForNeuron(neuron, MOVIES);
    chosenThresholdsVec = thresDict(neuron);
    artIdsForNeuron = artDict(neuron);
    [meanArts, meanNonArts] = getMeanArtsAndNonArts(neuronTraces, chosenThresholdsVec, artIdsForNeuron, 50, length(MOVIES));
    dissimVec = getArtNonArtDissim(meanArts, meanNonArts, [8, 37]);
    positions = generatePositionDict3(6, 10, .02, .04);
    subplot('Position', positions{i})
    hold on
    title(num2str(neuron))
    plot(nOfSpikesDetDict(neuron))
    plot(dissimVec / max(dissimVec) * 50, 'r.-')
end
