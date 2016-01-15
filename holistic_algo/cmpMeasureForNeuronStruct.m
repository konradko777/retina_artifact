function [ fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec] ...
    = cmpMeasureForNeuronStruct(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle)
% full = for every movie
    fullMeasureMatrix = zeros(length(movies), length(thresholds), length(thresholds));
    fullArtifactIDsMatrix = cell(length(movies), 1); 
    fullClustArtNumVec = getClusterArtNum(neuronID, movies);
    for i = 1:length(movies)
        movie = movies(i);
        [measureMatrix, artifactIDsMatrix] = cmpMeasureForNeuronMovie(neuronID, movie, thresholds, samplesLim, algoHandle, measureHandle); %%added 
        fullMeasureMatrix(i, :, :) = measureMatrix;
        fullArtifactIDsMatrix{i} = artifactIDsMatrix;
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