
addJava
global TRACES_NUMBER_LIMIT EVENT_NUMBER NEURON_ELE_MAP
TRACES_NUMBER_LIMIT=50;
EVENT_NUMBER=0;
DATA_PATH = 'E:/retina_data/2012_09_24_00';
EI_PATH = 'E:/retina_data/2012_09_24_00/data000/data000.ei';
load('neuronIdx_00')
load('neuronEleMap_00')

%%
clear('ds')
ds = DataSet(DATA_PATH, 'largestQT');

%%
qtServer = QTThresholdServer();

%%

neuron = NEURON_IDS(3);
ele = NEURON_ELE_MAP(neuron);
traces = ds.getTracesForPatternMovieEle(ele, 21, ele);
plot(traces')

%%
% clear QTClassifier
QTClassifier =  QTArtClassifier();
% [artIds, highestQT] = QTClassifier.classifyArtifacts(traces);

%%
ds.attachArtClassifierObj(QTClassifier)
ds.attachThresServerObj(qtServer)
% artIDs = ds.getArtIDsAndLargestQT(ele, 21, ele);
%%
meanArt = ds.getMeanArtForMovie(ele, 21, ele);
plot(meanArt);
%%
movies = (2:2:64) - 1;
meanArts = ds.getMeanArtsForMovies(ele, movies, ele);

%%
movieIdx = 11;
meanArt = meanArts(movieIdx, :);
spikeTrace = traces(2,:);

%%
clear spikeDetector
spikeDetector = SimpleSpikeDetector([8 37]);
% [a, b] = spikeDetector.detectSpike(spikeTrace, meanArt, -200)
spikeMat = spikeDetector.detectSpikesForMovie(traces, meanArt, -100, 21)