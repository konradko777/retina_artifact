function [firstEligibleMovie, minimumIdx] = getApplicabilityRange(artifactsFoundPerMovie)
    minArts = 20;
    maxArts = 40;
    tolerance = 0;
    [~, locs] = findpeaks(-artifactsFoundPerMovie, 'MINPEAKHEIGHT', -minArts - tolerance );
    minimumIdx = locs(1);
    firstEligibleMovie = minimumIdx;
    while firstEligibleMovie > 0 && artifactsFoundPerMovie(firstEligibleMovie) < maxArts
        firstEligibleMovie = firstEligibleMovie - 1;
    end
    firstEligibleMovie = firstEligibleMovie + 1;
end

% 
% function findFirstEligibleMin(artifactsFoundPerMovie, minimalArts)
%     lessThan = artifactsFoundPerMovie < minimalArts;
%     
% 
% end