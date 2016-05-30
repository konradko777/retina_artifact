function thresFirstIndices = getFirstThresIdxForMovies(stabilityIslForNeuron)
% Zero in output means no stability Island found
    nMovies = size(stabilityIslForNeuron, 1);
    thresFirstIndices = zeros(nMovies, 1);
    for movie = 1:nMovies
        stabIslForMovie = stabilityIslForNeuron{movie};
        if stabIslForMovie
            thresFirstIndices(movie) = stabIslForMovie(1);
        end

    end
end