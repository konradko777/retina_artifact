function [ fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetected, movieIdx] = ...
    holisticAlgo1(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle, breachFunction, minimalCluster, spikeDetMarigin, howManySpikes)


[fullMeasureMatrix, fullArtifactIDsMatrix, fullClustArtNumVec] = cmpMeasureForNeuronStruct(neuronID, movies, thresholds, samplesLim, algoHandle, measureHandle);
stableThresholdsMat = getMinStableThresForMovies(fullMeasureMatrix, movies, thresholds, breachFunction, minimalCluster);
stableThresVec = chooseStableThresIdx(stableThresholdsMat);
spikesDetected = detectSpikesForNeuron(neuronID, movies, fullArtifactIDsMatrix, stableThresVec, spikeDetMarigin, samplesLim);
movieIdx = chooseMovie(spikesDetected, howManySpikes);


end

function movieIdx = chooseMovie(spikesDetectedVec, howManySpikes)
    movieIdx = find(spikesDetectedVec > howManySpikes, 1);
end