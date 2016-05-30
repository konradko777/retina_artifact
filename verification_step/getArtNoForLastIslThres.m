function artNoVec = getArtNoForLastIslThres(fullArtMat, stableIslMat)
    lastThresholdxVec = getLastThresIdxForMovies(stableIslMat);
    nMovies = size(fullArtMat, 1);
    artNoVec = zeros(nMovies, 1);
    for movie = 1:nMovies
        lastThresIdx = lastThresholdxVec(movie);
        if lastThresIdx
            movieArtMat = fullArtMat{movie};
            artNoVec(movie) = length(movieArtMat{lastThresIdx});
        else
            artNoVec(movie) = -1;
        end
        
    end


end