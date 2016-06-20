
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
ds = DataSet(DATA_PATH, 'largestQT', 1:2:63, [10 48]);

%%
qtServer = QTThresholdServer();

%%

neuron = NEURON_IDS(3);
ele = NEURON_ELE_MAP(neuron);
traces = ds.getTracesForPatternMovieEle(ele, 21, ele);
plot(traces')

%%
clear QTClassifier
QTClassifier =  QTArtClassifier();
% [artIds, highestQT] = QTClassifier.classifyArtifacts(traces);

%%
clear spikeDetector
spikeDetector = SimpleSpikeDetector([8 37]);
% [a, b] = spikeDetector.detectSpike(spikeTrace, meanArt, -200)
% spikeMat = spikeDetector.detectSpikesForMovie(traces, meanArt, -100, 21)

%%
clear interpreter
interpreter = resultInterpreter([10, 48]);
%%
FULL_EFF_APPROX = .92;
clear ampSelectorObj
ampSelectorObj = StimAmpSelector(FULL_EFF_APPROX);

%%
ds.attachArtClassifierObj(QTClassifier)
ds.attachThresServerObj(qtServer)
ds.attachSpikeDetectorObj(spikeDetector)
ds.attachInerpreterObj(interpreter)
ds.attachStimAmpSelectorObj(ampSelectorObj);
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
movies =  1:2:63;
allTraces = ds.getAllTracesForPatternEle(ele, ele, movies);
meanArts = ds.getMeanArtsForMovies(allTraces, ele, ele, movies);    
spikesMat = ds.detectSpikesForAllMovies(allTraces, meanArts, ele, ele, movies);
spikeVec = ds.transformSpikeMatToVec(spikesMat, movies);
interpretationVec = ds.interpretResults(spikeVec);

%%
[interpretationVector, artifactEstimates, spikeMatrix] = ds.analyzeSEREpair(ele, ele);
optimalStimAmp = ds.selectOptimalStimAmp(spikeMatrix, interpretationVector);
%%
[electrodes, amps] = ds.estimateBestStimAmpsForClosestEles(ele, ele);

%% fitting debug
problematicEle = 197;
[interpretationVector, artifactEstimates, spikeMatrix] = ds.analyzeSEREpair(problematicEle, ele);

%% best ele
bestEle = ds.chooseBestStimulationElectrode(ele);