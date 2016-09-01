function confusionMatrix = compareClassifications(spikeMatrix, interpretationVector, elecRespStruct)
    latencies = elecRespStruct.analysis.latencies;
    bothSpikes = 0;
    bothArts = 0;
    manualArtsAlgSpikes = 0;
    manualSpikesAlgArts = 0;
    for movieIdx = 1:size(latencies, 1)
        cmpVec = createComparisonVecFromSpikeMat(movieIdx, spikeMatrix,...
            interpretationVector, elecRespStruct.stimInfo.nPulses);
        manualClassVec = logical(elecRespStruct.analysis.latencies{movieIdx});
        bothSpikes = bothSpikes + sum(cmpVec & manualClassVec);
        bothArts = bothArts + sum(~(cmpVec | manualClassVec));
        manualArtsAlgSpikes = manualArtsAlgSpikes + sum(cmpVec & ~manualClassVec);
        manualSpikesAlgArts = manualSpikesAlgArts + sum(~cmpVec & manualClassVec);
    end
    confusionMatrix = [bothArts, manualArtsAlgSpikes;
                       manualSpikesAlgArts, bothSpikes];

end


function cmpVec = createComparisonVecFromSpikeMat(movieIdx, spikeMatrix,...
    interpretationVec, nPulsesVec)
    nPulses = nPulsesVec(movieIdx);
    cmpVec = zeros(nPulses,1);
    if interpretationVec(movieIdx)
        for i = 1:size(spikeMatrix, 1)
            if spikeMatrix(i,1) == movieIdx
                cmpVec(spikeMatrix(i,2)) = 1;
            end
        end
    else
        cmpVec = ones(nPulses,1);
    end
end