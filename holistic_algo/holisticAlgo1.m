function [ fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetectedVec, movieIdx] = ...
    holisticAlgo1(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle, breachFunction, minimalCluster, spikeDetMarigin, howManySpikes)


[fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec] = cmpMeasureForNeuronStruct(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle);
stableThresholdsMat = getMinStableThresForMovies(fullMeasureMatrix, movies, thresholds, breachFunction, minimalCluster);
stableThresVec = chooseStableThresIdx(stableThresholdsMat);

spikesDetectedVec = detectSpikesForNeuron(neuronID, movies, fullArtifactIDsMatrix, stableThresVec, spikeDetMarigin, samplesLim);
movieIdx = chooseMovie(spikesDetectedVec, howManySpikes);


end

function movieIdx = chooseMovie(spikesDetectedVec, howManySpikes)
    movieIdx = find(spikesDetectedVec > howManySpikes, 1);
end