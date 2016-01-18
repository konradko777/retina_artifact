function [spikeTraces, artifactTraces] = getSpikeArtTracesForNeuron(neuronID)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    global NEURON_CLUST_FILE_MAP NEURON_HALF_EFF_MOVIE_MAP NEURON_ELE_MAP
    global NEURON_REC_ELE_MAP
    movieNumber = NEURON_HALF_EFF_MOVIE_MAP(neuronID);
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    recordingEle = NEURON_REC_ELE_MAP(neuronID);
    [spikeIDs, artifactIDs] = getSpikeArtIDs(clusterFileName,movieNumber,patternNumber);
    eleTraces = getMovieEleTraces(movieNumber, recordingEle);
    spikeTraces = eleTraces(spikeIDs, :);
    artifactTraces = eleTraces(artifactIDs, :);
end


function [spikeIDs , artifactIDs]= getSpikeArtIDs(clusterFileName,movieNumber,patternNumber)
    WaveformTypes=NS_ReadClusterFile(clusterFileName,movieNumber,patternNumber,50); %1 artefakt 2spike
    spikeIDs = find(WaveformTypes == 2);
    artifactIDs = find(WaveformTypes == 1);
end

