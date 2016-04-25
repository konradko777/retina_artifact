function mat = getNeuronAlgoThresAmps(nOfSpikesDetDict)
    global DATA_PATH NEURON_IDS
    ampMovieDict = createAmpMovieMap(DATA_PATH);
    movieAmpDict = reverseDict(ampMovieDict);
    allResults = zeros(0,4);
    bestMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
    i = 0;
    for neuron = NEURON_IDS
        i = i + 1;
        allResults(i, :) = [neuron, bestMoviesDict(neuron)];
    end
    mat = transformIndicesToAmps(allResults, movieAmpDict);
end


function transedAllResults = transformIndicesToAmps(allResults, movieAmpDict)
    transedAllResults = allResults;
    transedAllResults(transedAllResults <= 0) = .5;
    transedAllResults(:, 2:end) = transedAllResults(:, 2:end) * 2 - 1;
    transedAllResults(:, 2:end) = arrayfun(@(x) mapAmpIdxToAmp(x, movieAmpDict), transedAllResults(:, 2:end));
end