function setGlobals512()
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER NEURON_ELE_MAP 
    global NEURON_REC_ELE_MAP NEURON_IDS NEURON_THRES_FILE_MOVIE_MAP
    global ELE_NEURON_MAP EI_FILE NEURON_SPIKE_AMP_MAP ELE_MAP_OBJ
%     addJava
    ELE_MAP_OBJ = edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(500);
    DATA_PATH = 'E:\praca\dane\2012-09-27-4\scan_new';
    THRESHOLD_PATH = 'E:\praca\dane\2012-09-27-4\stim_scan\';
    THRES_FILE1 = [THRESHOLD_PATH 'thresholds_1'];
    THRES_FILE2 = [THRESHOLD_PATH 'thresholds_2'];
    CURRENT_AMP_MOVIE_MAP = createAmpMovieMap(DATA_PATH);
    [NEURON_IDS, StimEle, ThresFileAmp] = getNeuronIdsAndStimEle(THRES_FILE1, THRES_FILE2);
    NEURON_THRES_CURRENT_MAP = containers.Map(NEURON_IDS, ThresFileAmp);
    NEURON_THRES_FILE_MOVIE_MAP = createNeuronThresFileMovieMap(NEURON_THRES_CURRENT_MAP, CURRENT_AMP_MOVIE_MAP);
    EI_PATH = 'E:\praca\dane\2012-09-27-4\data000\data000.ei';
    EI_FILE = edu.ucsc.neurobiology.vision.io.PhysiologicalImagingFile(EI_PATH);
    NEURON_ELE_MAP = containers.Map(NEURON_IDS, StimEle);
    [EIElectrodes, EISpikeAmps] = findBestEleAndSpikeAmpFromEIForNeurons(NEURON_IDS);
    TRACES_NUMBER_LIMIT=50;
    EVENT_NUMBER=0;
    ELE_NEURON_MAP = containers.Map(StimEle, NEURON_IDS);
    NEURON_REC_ELE_MAP = containers.Map(NEURON_IDS, EIElectrodes);
    NEURON_SPIKE_AMP_MAP = containers.Map(NEURON_IDS, EISpikeAmps);
end

function neuronThresFileMovieMap = createNeuronThresFileMovieMap(neuronCurrentAmpDict, currentAmpMovieDict)
    neurons = keys(neuronCurrentAmpDict);
    neuronThresFileMovieMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
    for neuronCell = neurons
        neuron = neuronCell{1};
        currentAmp = neuronCurrentAmpDict(neuron);
        if currentAmp == 0
            movie = 0;
        else
            movie = currentAmpMovieDict(currentAmp);
        end
        neuronThresFileMovieMap(neuron) = movie;
    end

end

function [neuronIDs, electrodes, thresFileAmp]= getNeuronIdsAndStimEle(file1, file2)
    [neuronIDs, electrodes, thresFileAmp] = NS512_ReadThresholdFiles(file1, file2);
    neuronIDs = neuronIDs';
    electrodes = electrodes';
    thresFileAmp = thresFileAmp';
end

