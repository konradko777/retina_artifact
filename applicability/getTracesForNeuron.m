function neuronTraces = getTracesForNeuron(neuron, movies)
    testTraces = getTracesForNeuronMovie(neuron, 1);
    dims = size(testTraces);
    neuronTraces = zeros([length(movies) dims]); %%magic numbers
    i = 1;
    for movie = movies
        neuronTraces(i, :, :) = getTracesForNeuronMovie(neuron, movie);
        i = i + 1;
    end
end