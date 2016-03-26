global NEURON_IDS NEURON_THRES_FILE_MOVIE_MAP
for neuron = NEURON_IDS
    SFVec = nOfSpikesDetDict(neuron);
    thresMovieIdx = (NEURON_THRES_FILE_MOVIE_MAP(neuron) - 1) / 2;
    halfEff = findBestMovie(SFVec);
    fullEff = mapSFVecTo100PercMovieIdx(SFVec);
    s = sprintf('%d: half: %d, full: %d, thres: %d', neuron, halfEff, fullEff, thresMovieIdx);
    disp(s);
end
