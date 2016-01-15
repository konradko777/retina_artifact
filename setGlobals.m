function setGlobals()
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER NEURON_ELE_MAP 
    global NEURON_REC_ELE_MAP NEURON_CLUST_FILE_MAP NEURON_IDS
    global ELE_NEURON_MAP NEURON_HALF_EFF_MOVIE_MAP
    DATA_PATH = 'C:\studia\dane_skrypty_wojtek\data003';
    TRACES_NUMBER_LIMIT=50;
    EVENT_NUMBER=0;
    NEURON_IDS=[76 227 256 271 391 406 541 616 691 736 856 901];
    StimEle=[1 16 18 10 27 28 37 45 54 51 60 61];
    NEURON_ELE_MAP = containers.Map(NEURON_IDS, StimEle);
    ELE_NEURON_MAP = containers.Map(StimEle, NEURON_IDS);
    halfEfficiencyMovie = [8 6 18 15 10 17 11 1 2 8 9 21];
    NEURON_HALF_EFF_MOVIE_MAP = containers.Map(NEURON_IDS, halfEfficiencyMovie);
    recordingElectrode = [1 16 18 10 27 28 37 45 54 50 58 61]; %% neuron271 (4.) nietypowe zachowanie
    NEURON_REC_ELE_MAP = containers.Map(NEURON_IDS, recordingElectrode);
    NEURON_CLUST_FILE_MAP= createNeuronClustFileMap(NEURON_IDS);
end

function map = createNeuronClustFileMap(neuronIDs)
    global DATA_PATH
    prefix = [DATA_PATH '\ClusterFile_003_id'];
    n = length(neuronIDs);
    fileNames = cell(n,1);
    for i = 1:n
        fileNames{i} = [prefix num2str(neuronIDs(i))];
    end
    map = containers.Map(neuronIDs,fileNames);
    
end