function [minimumIdx, maximumIdx] = getApplicabilityRangeSpikes(spikesFoundPerMovie)
    
    maxSpikes = 30;
%     tolerance = 0;
    [~, locs] = findpeaks(spikesFoundPerMovie, 'MINPEAKHEIGHT', maxSpikes);
    maximumIdx = locs(1);
    minimumIdx = findMinMovie2(spikesFoundPerMovie, maximumIdx);


end

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