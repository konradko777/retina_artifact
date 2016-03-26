function dict_ = createHalfFullThresAmpIdxDict(nOfSpikesDetDict)
    global NEURON_IDS NEURON_THRES_FILE_MOVIE_MAP
    ampIndices = cell(size(NEURON_IDS));
    i = 1;
    for neuron = NEURON_IDS
        SFVec = nOfSpikesDetDict(neuron);
        thresMovieIdx = (NEURON_THRES_FILE_MOVIE_MAP(neuron) - 1) / 2;
        halfEff = findBestMovie(SFVec);
        fullEff = mapSFVecTo100PercMovieIdx(SFVec);
        ampIndices{i} = [halfEff, fullEff, thresMovieIdx];
        i = i + 1;
    end
    dict_ = containers.Map(NEURON_IDS, ampIndices);
end