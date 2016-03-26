function fullEffMovie = mapSFVecTo100PercMovieIdx(SFVec)
    [~, maxMovie] = getApplicabilityRangeSpikes512(SFVec);
    fullEffMovie = -1;
    if maxMovie > 0 && maxMovie < 32
        fullEffMovie = maxMovie + 1;
    end
end