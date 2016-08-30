%% reading data from elecResp files

DATA_PATH = 'E:\praca\dane_2016_08\2014-11-05-3\data001\';
succes = {};
i = 0;
j = 0;
noi = {}; %neurons of interest
neuronPatterns = [];
neuronRecEles = [];
neuronSuccesRate = {};
neuronLatencies = {};
patternMovies = {};
for file_ = dir([DATA_PATH 'elecResp*'])'
    i = i + 1;
    load([DATA_PATH file_.name])
    if any(elecResp.analysis.successRates)
        j = j + 1;
        noi{j} = elecResp;
%         [tokens, ~] = regexp(file_.name, 'n(\d+)_p(\d)+', 'tokens','match');
%         noi(j) = str2num(tokens{1}{1});
%         neuronRecEles(j) = elecResp.cells.recElec;
%         neuronPatterns(j) = str2num(tokens{1}{2});
%         neuronSuccesRate{j} = elecResp.analysis.successRates;
%         neuronLatencies{j} = elecResp.analysis.latencies;
%         patternMovies{j} = elecResp.stimInfo.movieNos;
    end
%     sprintf('%s %d, %d', file_.name, any(succes{i}), any(cellfun(@any, elecResp.analysis.otherLatencies)))
end
%% checkin whethe sitmulus duration is constant
i = 0;
pulses = {};
hold on
for file_ = dir([DATA_PATH 'elecResp*'])'
    i = i + 1;
    load([DATA_PATH file_.name])
    pulses = cellfun(@squeeze, elecResp.stimInfo.pulseVectors, 'UniformOutput', false);
    for j = 1: size(pulses, 1)
        plot(pulses{j}(1,:), pulses{j}(2,:));
        disp('a')
    end
end
%% QT art classifier globals
SAMPLES_OF_INTEREST = [8 37];
ART_TO_PRUNE = 2; % how many most differing artifact candidates should be dropped
VOTES_TO_EXCLUDE = 3; % how many votes are needed to exclude given trace
% from artifact candidate set
MINIMAL_CLUSTER = 3; % minimal number of thresholds do declare stability
% island
STABILITY_THRESHOLD = 30; % threshold used when determining stability island.
% Mind its indirect connection to SAMPLES_OF_INTEREST
QTs = 10:5:100; % quantization thresholds used when lookin for optimal one.
APPLICATION_RANGE = [4 19]; % TODO: zautomatyzowac z uwagi na rozna ilosc stymulacji? %%%%%%%%%%%
FULL_EFF_APPROX = .92;
%%
VISION_PATH = 'C:\studia\dane_skrypty_wojtek\ks_functions\Vision.jar';
dataSet = DataSet(DATA_PATH, VISION_PATH, noi{1}, ...
    64, 'spikedetectionmethod', APPLICATION_RANGE);
spikeDetectionThresholdServer= DummyThresholdServer( -40);
QTClassifier =  QTArtClassifier(SAMPLES_OF_INTEREST, ART_TO_PRUNE, ...
    VOTES_TO_EXCLUDE, QTs, MINIMAL_CLUSTER, STABILITY_THRESHOLD);
spikeDetector = SimpleSpikeDetector(SAMPLES_OF_INTEREST);
interpreter = resultInterpreter(APPLICATION_RANGE);
ampSelectorObj = StimAmpSelector(FULL_EFF_APPROX);
%% attaching 
dataSet.attachThresServerObj(spikeDetectionThresholdServer);
dataSet.attachArtClassifierObj(QTClassifier);
dataSet.attachSpikeDetectorObj(spikeDetector);
dataSet.attachInerpreterObj(interpreter)
dataSet.attachStimAmpSelectorObj(ampSelectorObj);

%%
pattern = 163;
movie = 49;
recEle = 170;
tracesNumberLimit = 21;
traces = dataSet.getTracesForPatternMovieEle(pattern, movie, recEle);
plot(traces')
meanArt = dataSet.getMeanArtForMovie(traces, pattern, movie, recEle);
hold on
plot(traces')
plot(meanArt, 'linewidth', 2, 'color', 'r')
%%
spikesDetectedMat = dataSet.detectSpikesForMovie(traces, meanArt, -40, movie);
%%
[interpretationVector, artifactEstimates, spikeMatrix] = dataSet.analyzeSEREpair(pattern, recEle);
%%
clear dataSet