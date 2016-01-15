function [ fullMergedMeasureMat, fullArtifactIDsMatrix, fullClustArtNumVec] ...
    = cmpRawDotProdForNeuronStruct(neuronID, movies, algoHandle, thresholds, samplesLim)
% full = for every movie
    fullNormDotMatrix = zeros(length(movies), length(thresholds), length(thresholds));
    fullRawDotMatrix = fullNormDotMatrix;
    fullArtifactIDsMatrix = cell(length(movies), 1); 
    fullClustArtNumVec = getClusterArtNum(neuronID, movies);
    for i = 1:length(movies)
        movie = movies(i);
        [normDotMatrix, rawDotMatrix, artifactIDsMatrix] = cmpDotForNeuronMovieStruct(neuronID, algoHandle, movie, thresholds, samplesLim);
        fullNormDotMatrix(i, :, :) = normDotMatrix;
        fullRawDotMatrix(i, :, :) = rawDotMatrix;
        fullArtifactIDsMatrix{i} = artifactIDsMatrix;
    end
    fullRawDotMatrix = normalizeRawMat(fullRawDotMatrix);
    fullMergedMeasureMat = fullRawDotMatrix; %mergeMeasureMatrices(fullNormDotMatrix, fullRawDotMatrix);
%     for i=1:size(fullMergedMeasureMat,1)
%         i
%         squeeze(fullMergedMeasureMat(i,:,:))
%     end
end


function normed = normalizeRawMat(rawMat)
    nMovies = size(rawMat,1);
    max_ = max(rawMat(:));
    min_ = min(rawMat(:));
    normed = (2*rawMat - (min_ + max_)) / (max_ - min_);

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