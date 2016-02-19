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
    if length(artifacts) > artToPrune
        excluded = pruneExtremeArtifacts(Waveforms, artifacts, artToPrune, samplesLim);
        artifacts = setdiff(artifacts, excluded);
    elseif isempty(artifacts)
        error('No artifacts were found');
    else
        excluded = [];
        disp('Not enough artifacts to prune');
    end
    resultStruct.artifactIDs = artifacts;
    resultStruct.excluded = excluded;
    resultStruct.spikes = spikes;
end