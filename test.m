compareEles = zeros(length(NEURON_IDS), 3);
global NEURON_THRES_FILE_MOVIE_MAP

for i = 1:70
    neuron = NEURON_IDS(i);
    compareEles(i, 1) = neuron;
    compareEles(i, 2) = NEURON_ELE_MAP(neuron);
    compareEles(i, 3) = stimEleFoundFixed(i);
    thresMovies(i) = NEURON_THRES_FILE_MOVIE_MAP(neuron);
end

compareEles(thresMovies == 0, 2) = 0;
[NEURON_IDS' compareEles(:,2) == compareEles(:,3)]
sum(compareEles(:,2) == compareEles(:,3)) / length(NEURON_IDS)