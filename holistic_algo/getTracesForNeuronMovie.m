function traces = getTracesForNeuronMovie(neuronID, movie)
    global NEURON_REC_ELE_MAP
    recordingEle = NEURON_REC_ELE_MAP(neuronID);
    traces = getMovieEleTraces(movie, recordingEle);

end