function bestStimEle = findBestStimEle(eleHalfEffMovieMat)
    [~, minIdx] = min(eleHalfEffMovieMat(:, 2));
    bestStimEle = eleHalfEffMovieMat(minIdx, 1);
end