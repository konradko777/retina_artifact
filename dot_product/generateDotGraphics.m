global NEURON_CLUST_FILE_MAP NEURON_IDS
movies = 1:24; %amplitdes seen on plot, currently must be 24 of them
for neuron = NEURON_IDS
%     NEURON_CLUST_FILE_MAP(neuron)
    sheetDotProdMeasure(neuron, movies)
end