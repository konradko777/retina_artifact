SAMPLES_LIM = [11 40];
MOVIES = 1:24;
THRESHOLDS = 10:5:100;
ART_TO_PRUNE = 2;
MINIMAL_CLUSTER = 3;
SPIKE_DET_MARG = 0;
HOW_MANY_SPIKES = 25;
PATH_ROOT = 'C:\studia\dane_skrypty_wojtek\ks_functions\applicability\';
addJava
setGlobals
algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, ART_TO_PRUNE, SAMPLES_LIM);
measureHandle = @cmpDiffMeasureVec;
thresBreach20 = @(simValuesVec) thresholdBreachFunc(simValuesVec, 30);
AMP_DICT = createNeuronSpikeAmpDict();
Y_LIM_DICT = createNeuronYLimDict();
COLOR_AXIS_LIM = [0 300];
