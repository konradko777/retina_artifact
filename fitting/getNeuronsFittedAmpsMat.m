function neuronAmpMat = getNeuronsFittedAmpsMat(nOfSpikesDetDict, MAX_VALUE, MIN_SPIKES, desiredEff)
    neuronSpikeDetVecMat = nOfSpikeVecDictToMat(nOfSpikesDetDict, 0);
    onlySpikeMat = neuronSpikeDetVecMat(:, 2:end);
    transformedOnlySpikeMat = zeros(size(onlySpikeMat));
    for i = 1:size(transformedOnlySpikeMat, 1)
        transformedOnlySpikeMat(i, :) = transformSpikeDetVec(onlySpikeMat(i,:), MAX_VALUE, MIN_SPIKES);
    end
    amplitudeValues = getAmpVals();
    allCoeffs = zeros(0,2);
    for i = 1:size(transformedOnlySpikeMat,1)
        nOfSpikesTransed = transformedOnlySpikeMat(i,:)';
        if max(nOfSpikesTransed) == 1
            allCoeffs(i, :) = lsqcurvefit(@sigmoidalFunc, [1, 0], amplitudeValues, transformedOnlySpikeMat(i,:)');
        else
            allCoeffs(i, :) = [0, 0];
        end
    end
    
    amps = zeros(1, size(transformedOnlySpikeMat,1));
    for i = 1:size(transformedOnlySpikeMat,1)
        coeffs = allCoeffs(i, :);
        if all(coeffs)
            amps(i) = sigmoidalInv(coeffs, desiredEff);
        end
    end
    neuronAmpMat = [neuronSpikeDetVecMat(:, 1) amps'];
end



function amplitudeValues = getAmpVals()
    global DATA_PATH
    ampMovieDict = createAmpMovieMap(DATA_PATH);
    movieAmpDict = reverseDict(ampMovieDict);
    nOfAmps = length(keys(movieAmpDict));
    amplitudeValues = zeros(nOfAmps, 1);
    for i = 1: nOfAmps
        amplitudeValues(i) = movieAmpDict(2*i - 1);    
    end
end