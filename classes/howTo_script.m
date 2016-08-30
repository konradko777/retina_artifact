%% globals
VISION_PATH = 'C:\studia\dane_skrypty_wojtek\ks_functions\Vision.jar'; % path to Vision java library.
DATA_PATH = 'E:/retina_data/2012_09_24_00';
MOVIES = 1:2:63; % these integers must agree with naming convention used 
% during experiment
SPIKE_DETECTION_METHOD = 'largestQT'; % only used to passs information about
%largest QT to threshold server object need to be set to largestQT when
% using QTThresholdServer object. If not it can be set whatever string.
SAMPLES_OF_INTEREST = [8 37]; % samples in each trace, that are taken under 
% when computing similarity measure between mean artifacts and when
% detecting spikes. Mind that the dissimilarity threshold is linked to 
% STABILITY_THRESHOLD, so both quantities should be considered when
% changing.
APPLICATION_RANGE = [10, 48]; % number of spikes for one amplitude that we
% define as application range. Especially the first value is important.
% If exceeded for any amplitude it triggers amp selection procedure
% (consult StimAmpSelector object documentation for details). Setting it
% for some small value exposes algorithm to noise. 
N_ELECTRODES = 512;
TRACES_NUMBER_LIMIT = 50; % # of repetition of stimulus for one amplitude
FULL_EFF_APPROX = .92; % full efficiency approximation used for determining
% sitmulation amplitude from fitted function
SAMPLING_RATE = 20000; % in Hertz 
%% QT art classifier globals
ART_TO_PRUNE = 2; % how many most differing artifact candidates should be dropped
VOTES_TO_EXCLUDE = 5; % how many votes are needed to exclude given trace
% from artifact candidate set
MINIMAL_CLUSTER = 3; % minimal number of thresholds do declare stability
% island
STABILITY_THRESHOLD = 30; % threshold used when determining stability island.
% Mind its indirect connection to SAMPLES_OF_INTEREST
QTs = 10:5:100; % quantization thresholds used when lookin for optimal one.
%% object creation
ds = DataSet(DATA_PATH,VISION_PATH, TRACES_NUMBER_LIMIT, N_ELECTRODES, SAMPLING_RATE, ...
    SPIKE_DETECTION_METHOD, MOVIES, APPLICATION_RANGE);
% 3 types of spike detection threshold servers:
spikeDetectionThresholdServer = QTThresholdServer(.9); % server that uses the biggest QT from
% stability island.
% spikeDetectionThresholdServer= DummyThresholdServer(-55); % same threshold is used for every
    % electrode pair
% spikeDetectionThresholdServer = ManualThresholdServer([205 205 -55; 12 35 -150], MOVIES); % you can set
    % specific threshold for every SERE pair or even amplitude specific.
QTClassifier =  QTArtClassifier(SAMPLES_OF_INTEREST, ART_TO_PRUNE, ...
    VOTES_TO_EXCLUDE, QTs, MINIMAL_CLUSTER, STABILITY_THRESHOLD);
spikeDetector = SimpleSpikeDetector(SAMPLES_OF_INTEREST);
interpreter = resultInterpreter(APPLICATION_RANGE);
ampSelectorObj = StimAmpSelector(FULL_EFF_APPROX);
%% object attachement
ds.attachArtClassifierObj(QTClassifier)
ds.attachThresServerObj(spikeDetectionThresholdServer)
ds.attachSpikeDetectorObj(spikeDetector)
ds.attachInerpreterObj(interpreter)
ds.attachStimAmpSelectorObj(ampSelectorObj);

%% usage
stimEle = 205;
recEle = stimEle;

[interpretationVector, artifactEstimates, spikeMatrix] = ds.analyzeSEREpair(stimEle, recEle);
optimalStimAmp = ds.selectOptimalStimAmp(spikeMatrix, interpretationVector);
[electrodes, amps] = ds.estimateBestStimAmpsForClosestEles(stimEle, recEle);
bestEle = ds.chooseBestStimulationElectrode(recEle);