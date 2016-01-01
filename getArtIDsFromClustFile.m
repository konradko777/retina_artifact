function artifact_ids = getArtIDsFromClustFile(ClusterFileName, PatternNumber, MovieNumber)
    %setGlobals
    DATA_PATH = 'data003';
    TRACES_NUMBER_LIMIT=50;
    EVENT_NUMBER=0;
    %EventNumber - sometimes pulse on one electrode is repeated twice during
    %the same movie (for example, two different orders of stimulating
    %electrodes are tried). In such case, EventNumber defines whether the
    %responses to the first or the second (or other) pulse should be given by
    %this function. If EventNumber==0, all responses are given.
    %TO_DO stworzyc setGlobals, przepisac funkcje
    WaveformTypes=NS_ReadClusterFile(ClusterFileName,MovieNumber,PatternNumber,50); %1 artefakt 2spike
    artifact_ids = find(WaveformTypes == 1);
end