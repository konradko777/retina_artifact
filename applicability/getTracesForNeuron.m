function neuronTraces = getTracesForNeuron(neuron, movies)
    testTraces = getTracesForNeuronMovie(neuron, 1);
    dims = size(testTraces);
    neuronTraces = zeros([length(movies) dims]); %%magic numbers
    for movie = movies
        neuronTraces(movie, :, :) = getTracesForNeuronMovie(neuron, movie);
    end
end