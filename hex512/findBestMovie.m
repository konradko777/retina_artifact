function bestMovie = findBestMovie(nOfSpikesVec)
    [minMovie, maxMovie] = getApplicabilityRangeSpikes512(nOfSpikesVec);
    if minMovie < 0
        bestMovie = -1; %there are no movies with efficiency 20<x<80%
    else
        slice = nOfSpikesVec(minMovie:maxMovie);
        [~, idx] = min(abs(slice - 25));
        bestMovie = minMovie + idx - 1;
    end
end