clear
addJava
global TRACES_NUMBER_LIMIT EVENT_NUMBER NEURON_ELE_MAP
TRACES_NUMBER_LIMIT=50;
EVENT_NUMBER=0;
DATA_PATH = 'E:/retina_data/2012_09_24_00';
EI_PATH = 'E:/retina_data/2012_09_24_00/data000/data000.ei';
load('neuronIdx_00')
load('neuronEleMap_00')

ds = DataSet(DATA_PATH, EI_PATH, NEURON_IDS);


% %%
% clear
% ctObj = ClassTest()