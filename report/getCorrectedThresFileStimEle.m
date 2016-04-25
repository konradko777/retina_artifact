function thresStimEle = getCorrectedThresFileStimEle(neuron)
    global NEURON_THRES_FILE_MOVIE_MAP NEURON_ELE_MAP
    thresFileMovie = NEURON_THRES_FILE_MOVIE_MAP(neuron); %0 when no 100% amp was found
    thresFileStimEle = NEURON_ELE_MAP(neuron);
    if ~thresFileMovie
        thresStimEle = 0;
    else
        thresStimEle = thresFileStimEle;
    end
end