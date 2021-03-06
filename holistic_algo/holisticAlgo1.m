function [ fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetectedVec, spikesDetectedIdxMat, movieIdx] = ...
    holisticAlgo1(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle, breachFunction, minimalCluster, howManySpikes, spikeDetectionThres)



[fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec] = cmpMeasureForNeuronStruct(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle);
stableThresholdsMat = getMinStableThresForMovies(fullMeasureMatrix, movies, thresholds, breachFunction, minimalCluster);
stableThresVec = chooseStableThresIdx(stableThresholdsMat);

[spikesDetectedVec,  spikesDetectedIdxMat] = detectSpikesForNeuron(neuronID, movies, fullArtifactIDsMatrix, stableThresVec, samplesLim, spikeDetectionThres);
movieIdx = chooseMovie(spikesDetectedVec, howManySpikes);


end

function movieIdx = chooseMovie(spikesDetectedVec, howManySpikes)
    movieIdx = find(spikesDetectedVec > howManySpikes, 1);
end