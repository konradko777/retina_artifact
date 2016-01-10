function electrodeTraces = getTraces(movieNo, electrodeNo)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER
    patternNumber = electrodeNo;
    [DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(...
        DATA_PATH,DATA_PATH,0,patternNumber,movieNo,TRACES_NUMBER_LIMIT,EVENT_NUMBER);
    electrodeTraces = squeeze(DataTraces(:, electrodeNo, :));
end