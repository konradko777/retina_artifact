function [ ArtifactsIDs ] = mgrEstimateArtifactSignal(Waveforms, Active, QuantTh, MinArtifactsNoToEstimate)

    nWaveforms = size(Waveforms,1);
    numberOfDRW = ones(nWaveforms,1);
    
    for iWave = 1:nWaveforms
        if Active(iWave) == 1
            tmpArtifact = Waveforms(iWave,:);
            numberOfDRW(iWave) = mgrNumberOfDisqualifyingResultantWaveforms(Waveforms, tmpArtifact, QuantTh, Active);
        end
    end
    
    artifacts = (numberOfDRW == 0);
    waveformIDs = 1:nWaveforms;
    ArtifactsIDs = waveformIDs(artifacts);
    
    if length(ArtifactsIDs) < MinArtifactsNoToEstimate
        if length(ArtifactsIDs) == 1
            Active(ArtifactsIDs) = 0;
            [ ArtifactsIDs ] = mgrEstimateArtifactSignal(Waveforms, Active, QuantTh, MinArtifactsNoToEstimate);
        else
            ArtifactsIDs = [];
        end
    end

end