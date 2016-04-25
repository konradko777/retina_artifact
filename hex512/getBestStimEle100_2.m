function bestStimEle = getBestStimEle100_2(resultStructsForNeuron)
    bestStimEle = 0;
    eleMovieIdxPairs = zeros(0,2);
    for i = 1:length(resultStructsForNeuron)
        result = resultStructsForNeuron{i};
        if result.bestMovie100Idx > 0
            eleMovieIdxPairs(i,:) = [result.StimEle, result.bestMovie100Idx];            
        end
    end
    bestMovies = eleMovieIdxPairs(:, 2);
    eleMovieIdxPairs = eleMovieIdxPairs(bestMovies ~= 0, :);
    if ~isempty(eleMovieIdxPairs)
        bestStimEle = findBestStimEle(eleMovieIdxPairs);
    end
end