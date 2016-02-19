function setGlobals512()
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER NEURON_ELE_MAP 
    global NEURON_REC_ELE_MAP NEURON_IDS
    global ELE_NEURON_MAP EI_FILE NEURON_SPIKE_AMP_MAP ELE_MAP_OBJ
%     addJava
    ELE_MAP_OBJ = edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(500);
    DATA_PATH = 'E:\praca\dane\2012-09-27-4\scan_new';
    THRESHOLD_PATH = 'E:\praca\dane\2012-09-27-4\stim_scan\';
    [NEURON_IDS, StimEle] = getNeuronIdsAndStimEle([THRESHOLD_PATH 'thresholds_1'], [THRESHOLD_PATH 'thresholds_2']);
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


function [neuronIDs, electrodes]= getNeuronIdsAndStimEle(file1, file2)
    [neuronIDs, electrodes, ~] = NS512_ReadThresholdFiles(file1, file2);
    neuronIDs = neuronIDs';
    electrodes = electrodes';

end