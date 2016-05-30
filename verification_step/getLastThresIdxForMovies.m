function thresLastIndices = getLastThresIdxForMovies(stabilityIslForNeuron)
% Zero in output means no stability Island found
    nMovies = size(stabilityIslForNeuron, 1);
    thresLastIndices = zeros(nMovies, 1);
    for movie = 1:nMovies
        stabIslForMovie = stabilityIslForNeuron{movie};
        if stabIslForMovie
            thresLastIndices(movie) = stabIslForMovie(end);
        end

    end
end