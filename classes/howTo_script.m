addJava
DATA_PATH = 'E:/retina_data/2012_09_24_00';
MOVIES = 1:2:63;
SPIKE_DETECTION_METHOD = 'largestQT';
SAMPLES_OF_INTEREST = [8 37];
APPLICATION_RANGE = [10, 48];
FULL_EFF_APPROX = .92;
%% object creation
ds = DataSet(DATA_PATH, SPIKE_DETECTION_METHOD, MOVIES, APPLICATION_RANGE);
qtServer = QTThresholdServer();
QTClassifier =  QTArtClassifier();
spikeDetector = SimpleSpikeDetector(SAMPLES_OF_INTEREST);
interpreter = resultInterpreter(APPLICATION_RANGE);
ampSelectorObj = StimAmpSelector(FULL_EFF_APPROX);
%% object attachement
ds.attachArtClassifierObj(QTClassifier)
ds.attachThresServerObj(qtServer)
ds.attachSpikeDetectorObj(spikeDetector)
ds.attachInerpreterObj(interpreter)
ds.attachStimAmpSelectorObj(ampSelectorObj);

%% usage
stimEle = 205;
recEle = stimEle;

[interpretationVector, artifactEstimates, spikeMatrix] = ds.analyzeSEREpair(stimEle, recEle);
optimalStimAmp = ds.selectOptimalStimAmp(spikeMatrix, interpretationVector);
[electrodes, amps] = ds.estimateBestStimAmpsForClosestEles(stimEle, recEle);