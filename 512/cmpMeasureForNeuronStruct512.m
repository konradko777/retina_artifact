function [ fullMeasureMatrix, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikeIDsMatrix, fullClustArtNumVec] ...
    = cmpMeasureForNeuronStruct512(movies, thresholds, samplesLim, algoHandle, measureHandle, recordingElectrode, patternNumber)

    fullMeasureMatrix = zeros(length(movies), length(thresholds), length(thresholds));
    fullArtifactIDsMatrix = cell(length(movies), 1); 
    fullExcludedIDsMatrix = cell(length(movies), 1); 
    fullSpikeIDsMatrix = cell(length(movies), 1); 
    fullClustArtNumVec = zeros(length(movies)); %getClusterArtNum(neuronID, movies);
    for i = 1:length(movies)
        movie = movies(i);
        [measureMatrix, artifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix]...
            = cmpMeasureForNeuronMovie512(movie, thresholds, samplesLim, algoHandle, measureHandle, recordingElectrode, patternNumber); %%added 
        fullMeasureMatrix(i, :, :) = measureMatrix;
        fullArtifactIDsMatrix{i} = artifactIDsMatrix;
        fullExcludedIDsMatrix{i} = excludedIDsMatrix;
        fullSpikeIDsMatrix{i} = spikesIDsMatrix;
    end
end

function clusterArtifactNumberVec = getClusterArtNum(neuronID, movies)
    global NEURON_ELE_MAP NEURON_CLUST_FILE_MAP
    clusterArtifactNumberMat = zeros(size(movies));
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    for i = 1:length(movies)
        clusterArtNo = length(getArtIDsFromClustFile(clusterFileName,patternNumber, movies(i)));
        clusterArtifactNumberVec(i) = clusterArtNo;
    end
end