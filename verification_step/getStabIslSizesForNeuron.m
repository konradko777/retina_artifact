function islandSizes = getStabIslSizesForNeuron(stabilityIslForNeuron)
    nMovies = size(stabilityIslForNeuron, 1);
    islandSizes = zeros(nMovies, 1);
    for movie = 1:nMovies
        islandSizes(movie) = length(stabilityIslForNeuron{movie});
    end


end