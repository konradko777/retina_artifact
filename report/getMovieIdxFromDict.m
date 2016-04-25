function indices = getMovieIdxFromDict(neurons, bestMoviesDict, columnIdx)
    indices = zeros(size(neurons));
    i = 0;
    for neuron = neurons
        i = i + 1;
        indVec = bestMoviesDict(neuron);
        indices(i) = indVec(columnIdx);        
    end
    



end