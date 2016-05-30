function dissimVec = getArtNonArtDissim(avgArt, avgNonArts, samplesOfInterest)
    min_ = samplesOfInterest(1);
    max_ = samplesOfInterest(2);
    
    dissimMat = abs(avgArt - avgNonArts);
    dissimVec = sum(dissimMat(:, min_:max_), 2);

end