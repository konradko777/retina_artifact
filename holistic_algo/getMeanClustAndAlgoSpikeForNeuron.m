function [meanClustSpike, meanAlgoSpike, meanAlgoArt] = getMeanClustAndAlgoSpikeForNeuron(neuronID, algoChosenMovie, movieAlgoArtIDs, sampleLim)
    global NEURON_CLUST_FILE_MAP NEURON_ELE_MAP
    global NEURON_REC_ELE_MAP
    spikeAmp = createNeuronSpikeAmpDict();
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    recordingEle = NEURON_REC_ELE_MAP(neuronID);
    [clustSpikeIDs, artifactIDs] = getSpikeArtIDs(clusterFileName,algoChosenMovie,patternNumber);
    eleTraces = getMovieEleTraces(algoChosenMovie, recordingEle);
    meanClustSpike = mean(eleTraces(clustSpikeIDs, :));
    meanAlgoArt = mean(eleTraces(movieAlgoArtIDs, :));
    
    [~, detectedSpikesVec] = detectSpikesForMovie(eleTraces, meanAlgoArt, spikeAmp(neuronID), sampleLim);
    meanAlgoSpike = mean(eleTraces(logical(detectedSpikesVec), :));
    
end

function [spikeIDs , artifactIDs]= getSpikeArtIDs(clusterFileName,movieNumber,patternNumber)
    WaveformTypes=NS_ReadClusterFile(clusterFileName,movieNumber,patternNumber,50); %1 artefakt 2spike
    spikeIDs = find(WaveformTypes == 2);
    artifactIDs = find(WaveformTypes == 1);
end