function eleTraces = getMovieEleTraces(movieNumber, electrodeNumber)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER
    [allDataTraces,~, ~]=NS_ReadPreprocessedData(DATA_PATH,DATA_PATH,0, electrodeNumber, movieNumber, TRACES_NUMBER_LIMIT, EVENT_NUMBER);
    eleTraces = (squeeze(allDataTraces(:, electrodeNumber, :)));
end