function ampIdx = test(SFVec)
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