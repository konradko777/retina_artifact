global NEURON_THRES_FILE_MOVIE_MAP

neuronsToCheck = [349, 1908, 3605, 7638];
neuronsToCheck = [110, 3245];

for neuron = keys(NEURON_THRES_FILE_MOVIE_MAP)
    neuron = neuron{1};
    if ~NEURON_THRES_FILE_MOVIE_MAP(neuron)
        neuron
    end
end