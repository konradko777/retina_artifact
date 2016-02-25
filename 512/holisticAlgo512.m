function [ fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetectedVec, spikesDetectedIdxMat, movieIdx] = ...
    holisticAlgo512(movies, thresholds, samplesLim, algoHandle, measureHandle, breachFunction, minimalCluster, howManySpikes, spikeDetectionThres,  recordingElectrode, patternNumber)



[fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec] =...
    cmpMeasureForNeuronStruct512(movies, thresholds, samplesLim, algoHandle, measureHandle, recordingElectrode, patternNumber);
stableThresholdsMat = getMinStableThresForMovies(fullMeasureMatrix, movies, thresholds, breachFunction, minimalCluster);
stableThresVec = chooseStableThresIdx(stableThresholdsMat);

[spikesDetectedVec,  spikesDetectedIdxMat] = detectSpikesForNeuron512(recordingElectrode, patternNumber, movies, fullArtifactIDsMatrix, stableThresVec, samplesLim, spikeDetectionThres);
movieIdx = chooseMovie(spikesDetectedVec, howManySpikes);


end

function movieIdx = chooseMovie(spikesDetectedVec, howManySpikes)
    movieIdx = find(spikesDetectedVec > howManySpikes, 1);
end