function traces = getTracesForNeuronMovie(neuronID, movie)
    global NEURON_REC_ELE_MAP NEURON_ELE_MAP
    recordingEle = NEURON_REC_ELE_MAP(neuronID);
    pattern = NEURON_ELE_MAP(neuronID);
    traces = getMovieElePatternTraces(movie, recordingEle, pattern);

end