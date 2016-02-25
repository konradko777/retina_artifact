function [minimumIdx, maximumIdx] = getApplicabilityRangeSpikes512(spikesFoundPerMovie)
    minSpikes = 8;
    maxSpikes = 50;
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

% function [minimumIdx, maximumIdx] = getApplicabilityRangeSpikes512(spikesFoundPerMovie)
%     maximaLog = false(size(spikesFoundPerMovie));
%     minimaLog = false(size(spikesFoundPerMovie));
%     minSpikes = 10;
%     maxSpikes = 45;
%     [~, maxima] = findpeaks(spikesFoundPerMovie);
%     [~, minima] = findpeaks(-spikesFoundPerMovie);
%     maximaLog(maxima) = true;
%     minimaLog(minima) = true;
%     moreThanMin = spikesFoundPerMovie > minSpikes;
%     lessThanMax = spikesFoundPerMovie < maxSpikes;
%     maximumIdx = find(maximaLog & lessThanMax);
%     minimumIdx = find(minimaLog & moreThanMin);
%     if isempty(minimumIdx)
%         minimumIdx = find(moreThanMin,1);
%     end
%     
% end

function minimumIdx = findMinMovie1(spikesFoundPerMovie, maxMovie)
    [~, locs2] = findpeaks(-spikesFoundPerMovie);
    minimumIdx = locs2(locs2 < maxMovie);
    if isempty(minimumIdx)
        minimumIdx = 1;
    else
        minimumIdx = minimumIdx(end);
    end

end

function minimumIdx = findMinMovie2(spikesFoundPerMovie, maxMovie)
    MINIMAL_SPIKES = 8;
    minimumIdx = maxMovie;
    while minimumIdx > 0 && spikesFoundPerMovie(minimumIdx) >= MINIMAL_SPIKES
        minimumIdx = minimumIdx - 1;
    end
    minimumIdx = minimumIdx + 1;
end


% 
% function findFirstEligibleMin(artifactsFoundPerMovie, minimalArts)
%     lessThan = artifactsFoundPerMovie < minimalArts;
%     
% 
% end