function transVec = transformSpikeDetVec(spikeVec, maxValue, minSpikes)
    transVec = spikeVec;
    [minIdx, maxIdx] = getApplicabilityRangeSpikes(spikeVec);
    if maxIdx < 1
        transVec = transVec ./ maxValue;
        return
    end
    appIndices = minIdx:maxIdx;
    [~, maxAppIdx] = max(spikeVec(appIndices));
    maxIdx = appIndices(maxAppIdx);
    if maxIdx < length(spikeVec) && maxIdx > 0;
        transVec(maxIdx + 1:end) = maxValue;
    end
    transVec = transVec ./ maxValue;
end

function [minimumIdx, maximumIdx] = getApplicabilityRangeSpikes(spikesFoundPerMovie)
    minSpikes = 8;
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
    


% function transVec = transformSpikeDetVec(spikeVec, maxValue, minSpikes)
%     [maxSpikes, maxIdx] = max(spikeVec);
%     transVec = spikeVec;
%     if maxSpikes > minSpikes
%         transVec(maxIdx + 1:end) = maxValue;
%     end
%     transVec = transVec ./ maxValue;
% end

