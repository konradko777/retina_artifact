function movieIdx = mapArtVecTo100PercMovieIdx(artVec, nMovies)
    [~, movieIdx] = min(artVec);
    if movieIdx < nMovies
        movieIdx = movieIdx + 1;
    end
end