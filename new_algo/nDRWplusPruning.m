function [ resultStruct] = nDRWplusPruning(Waveforms, QuantTh, nDRW, artToPrune, samplesLim)
    %resultStruct fields: artifactIDs, excluded, spikes
    %samplesLim - format [min max] first and last sample taken under
    %   cosideration, the samples outside boundaries are ignored
    resultStruct = struct();
    nWaveforms = size(Waveforms,1);
    numberOfDRW = ones(nWaveforms,1);
    tracesIDs = 1:nWaveforms;
    for iWave = tracesIDs
        tmpArtifact = Waveforms(iWave,:);
        numberOfDRW(iWave) = nDRWFunction(Waveforms, tmpArtifact, QuantTh, samplesLim);
    end
        artifacts = tracesIDs(numberOfDRW < nDRW);
    spikes = setdiff(1:nWaveforms, artifacts);
    excluded = pruneExtremeArtifacts(Waveforms, artifacts, artToPrune, samplesLim);
    if length(artifacts) > artToPrune
        artifacts = setdiff(artifacts, excluded);
    else
        disp('Not enough artifacts to prune');
    end
    resultStruct.artifactIDs = artifacts;
    resultStruct.excluded = excluded;
    resultStruct.spikes = spikes;
end