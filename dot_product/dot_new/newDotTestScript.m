SAMPLES_LIM = [11 40];

algoHandle = @(traces, threshold) nDRWplusPruning(traces, threshold, 5, SAMPLES_LIM);
[a, b] = cmpDotProdForNeuronsStruct([76], [8, 9], algoHandle, [5,20, 60], SAMPLES_LIM);