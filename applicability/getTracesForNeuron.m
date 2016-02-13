function neuronTraces = getTracesForNeuron(neuron, movies)
    neuronTraces = zeros(length(movies), 50, 70); %%magic numbers
    for movie = movies
        neuronTraces(movie, :, :) = getTracesForNeuronMovie(neuron, movie);
    end
end