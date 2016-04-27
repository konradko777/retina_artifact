function newDict = rewrite100EffInAllResultsDict(allResStructsDict)
% when two valus are equal max the first one is found: bug or feature?
    global NEURON_IDS
    neuronsCellStructs = cell(size(NEURON_IDS));
    j = 0;
    for neuron = NEURON_IDS
        j = j + 1;
        neuronResStructs = allResStructsDict(neuron);
        for i = 1:length(neuronResStructs)
            electrodeResStruct = neuronResStructs{i};
            electrodeResStruct.bestMovie100Idx = mapSpikesFoundVecToBestAmpIdx(electrodeResStruct.spikesDetectedVec);
            neuronResStructs{i} = electrodeResStruct;
            %tutaj przesunac przepisywanie elektrody
%             if old100EffIdx > 0
%                 electrodeResStruct.StimEle
%                 electrodeResStruct.bestMovie100Idx
%                 electrodeResStruct.bestMovie100Idx = mapSpikesFoundVecToBestAmpIdx(electrodeResStruct.spikesDetectedVec)
%                 subplot(2,4, i)
%                 hold on
%                 plot(electrodeResStruct.spikesDetectedVec, 'b.-')
%                 line([old100EffIdx old100EffIdx], ylim, 'color', 'r')
%                 line([electrodeResStruct.bestMovie100Idx electrodeResStruct.bestMovie100Idx], ylim, 'color', 'g')
%             end
        end
        neuronsCellStructs{j} = neuronResStructs;
    end
    newDict = containers.Map(NEURON_IDS, neuronsCellStructs);
end

function ampIdx = mapSpikesFoundVecToBestAmpIdx(SFVec)
    [minIdx, maxIdx] = getApplicabilityRangeSpikes(SFVec);
    ampIdx = 0;
    if maxIdx < 1
        return
    end
    appIndices = minIdx:maxIdx;
    [~, maxAppIdx] = max(SFVec(appIndices));
    maxIdx = appIndices(maxAppIdx);
    if maxIdx < length(SFVec) && maxIdx > 0;
        ampIdx = maxIdx + 1;
    end
end

function [minimumIdx, maximumIdx] = getApplicabilityRangeSpikes(spikesFoundPerMovie)
    minSpikes = 9;
    maxSpikes = 49;
    moreThanMin = spikesFoundPerMovie > minSpikes;
    lessThanMax = spikesFoundPerMovie < maxSpikes;
    inAppRange = moreThanMin & lessThanMax;
    [minimumIdx, lChunk] = findLongestChunk(inAppRange);
    maximumIdx = minimumIdx + lChunk - 1;
    
end

function [idx, longestChunk] = findLongestChunk(logVec)
    idx = -1;
    longestChunk = 0;
    for i = 1:length(logVec)
        lOfChunk = 0;
        if logVec(i)
            for j = i:length(logVec)
                if logVec(j)
                    lOfChunk = lOfChunk + 1;
                else
                    break
                end
            end
        end
        if lOfChunk > longestChunk
            idx = i;
            longestChunk = lOfChunk;
        end
    end

end