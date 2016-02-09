function nOfArtsVec = getNOfArtsForMovies(movies, fullArtifactIDsMatrix, stableThresVec)
    nOfArtsVec = zeros(size(movies));
    i = 1;
    for movie = movies
        nOfArtsVec(i) = length(fullArtifactIDsMatrix{movie}{stableThresVec(movie)});
        i = i + 1;
    end

end