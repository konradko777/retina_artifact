function [ fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, ...
    spikesIDsMatrix, fullClustArtNumVec, stableThresVec, spikesDetectedVec,...
    spikesDetectedIdxMat, movieIdx, stabilityIslands] = ...
    holisticAlgo512(movies, thresholds, samplesLim, algoHandle, measureHandle, breachFunction, minimalCluster, howManySpikes, spikeDetectionThres,  recordingElectrode, patternNumber)
%%stabilityIslands - indices for stability island thresholds for each movies


[fullMeasureMatrix, fullArtifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix, fullClustArtNumVec] =...
    cmpMeasureForNeuronStruct512(movies, thresholds, samplesLim, algoHandle, measureHandle, recordingElectrode, patternNumber);
stabilityIslands = getMinStableThresForMovies(fullMeasureMatrix, movies, thresholds, breachFunction, minimalCluster);
stableThresVec = chooseStableThresIdx(stabilityIslands);

[spikesDetectedVec,  spikesDetectedIdxMat] = detectSpikesForNeuron512(recordingElectrode, patternNumber, movies, fullArtifactIDsMatrix, stableThresVec, samplesLim, spikeDetectionThres);
movieIdx = chooseMovie(spikesDetectedVec, howManySpikes);


end

function movieIdx = chooseMovie(spikesDetectedVec, howManySpikes)
    movieIdx = find(spikesDetectedVec > howManySpikes, 1);
end