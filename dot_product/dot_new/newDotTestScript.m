SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 20:5:60;
ART_TO_PRUNE = 2;
addJava
setGlobals
global NEURON_IDS
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
NEURON_IDS=256;
for neuronID = NEURON_IDS
    [measure, artifactsMat, clustVec ] = cmpDotProdForNeuronStruct(neuronID, MOVIES, algoHandle, THRESHOLDS , SAMPLES_LIM); %%%
    sheetDotProdMeasureStruct(neuronID, MOVIES, THRESHOLDS , measure, artifactsMat, clustVec)
end