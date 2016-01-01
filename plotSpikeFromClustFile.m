function plotSpikeFromClustFile(ClusterFileName, MovieNumber)
    setGlobals
    global TRACES_NUMBER_LIMIT
    recordingEle = getRecordingEle(ClusterFileName);
    PatternNumber = recordingEle;
    
    WaveformTypes=NS_ReadClusterFile(ClusterFileName,MovieNumber, ...
        PatternNumber,TRACES_NUMBER_LIMIT); %1 artefakt 2spike
    spikeIDs = find(WaveformTypes == 2);
    artifactIDs = negateTracesSet(TRACES_NUMBER_LIMIT, spikeIDs);
    figure
    sprintf('Spike: %d, artifacts: %d', length(spikeIDs), length(artifactIDs))
    hold on
    plotAdjacentTo(recordingEle, PatternNumber, MovieNumber, spikeIDs, 'g')
    plotAdjacentTo(recordingEle, PatternNumber, MovieNumber, artifactIDs, 'r')
    
end

function recordingEle = getRecordingEle(ClusterFileName)
    global NEURON_ELE_MAP
    index_ = strfind(ClusterFileName, 'id');
    neuronID = str2num(ClusterFileName(index_ + 2 : end));
    recordingEle = NEURON_ELE_MAP(neuronID);
end

function negated = negateTracesSet(numOfTraces, traces)
    negated = setdiff(1:numOfTraces, traces);
end
    