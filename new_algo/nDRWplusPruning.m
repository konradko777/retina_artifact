function [ resultStruct] = nDRWplusPruning(Waveforms, QuantTh, nDRW, samplesLim)
    %resultStruct fields: artifactIDs, excluded, spikes
    %samplesLim - format [min max] first and last sample taken under
    %cosideration, the samples outsideboundaries are ignored
    
    %samplesLim = [11 40]; %!!!!!!!!!!!!!!!!!
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
    excluded = pruneExtremeArtifacts(Waveforms, artifacts, 2, samplesLim);
    artifacts = setdiff(artifacts, excluded);
    resultStruct.artifactIDs = artifacts;
    resultStruct.excluded = excluded;
    resultStruct.spikes = spikes;
end