function [ fullNormDotMatrix, fullRawDotMatrix] = cmpDotProdForNeuronStruct(neuronID, movies, algoHandle, thresholds, samplesLim)
    fullNormDotMatrix = zeros(length(movies), length(thresholds), length(thresholds));
    fullRawDotMatrix = fullNormDotMatrix;
    
    for i = 1:length(movies)
        movie = movies(i);
        [normDotMatrix, rawDotMatrix] = cmpDotForNeuronStruct(neuronID, algoHandle, movie, thresholds, samplesLim);
        fullNormDotMatrix(i, :, :) = normDotMatrix;
        fullRawDotMatrix(i, :, :) = rawDotMatrix;
    end
end

