
%%
addJava
setGlobals512
load stimEleFoundFixed

%% getting apmplitude values
global DATA_PATH
ampMovieDict = createAmpMovieMap(DATA_PATH);
movieAmpDict = reverseDict(ampMovieDict);
nOfAmps = length(keys(movieAmpDict));
amplitudeValues = zeros(nOfAmps, 1);
for i = 1: nOfAmps
    amplitudeValues(i) = movieAmpDict(2*i - 1);    
end

%%
NEURON_ID = 4401;
movie = 63;
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
moviesToInclude = (17:24) * 2 - 1;

path = 'C:\studia\dane_skrypty_wojtek\ks_functions\appendix\graph\';
for NEURON_ID = NEURON_ID%= NEURON_IDS
    eiSpike = getEISpikeForNeuronEle(NEURON_ID, NEURON_REC_ELE_MAP(NEURON_ID));
    eiSpikeAmp = NEURON_SPIKE_AMP_MAP(NEURON_ID);
    detectionThres = SPIKE_DETECTION_THRES_DICT(NEURON_ID);
    allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
    nOfSpikesVec = nOfSpikesDetDict(NEURON_ID);
    allTracesSubtracted = subtractMeanArtFromMovies(allTraces, artDict(NEURON_ID), thresDict(NEURON_ID), MOVIES, nOfSpikesVec);
    [minMovie, maxMovie] = getApplicabilityRangeSpikes512(nOfSpikesVec);
    f = figure();
    set(gcf, 'InvertHardCopy', 'off');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
    plotTracesForNeuronNonLinAmp(NEURON_ID, detectedSpikesDict(NEURON_ID), artDict(NEURON_ID), ...
        spikeDict(NEURON_ID), thresDict(NEURON_ID), allTraces, MOVIES,...
        THRESHOLDS, nOfSpikesVec, eiSpike, eiSpikeAmp, detectionThres, efficiencyMoviesDict(NEURON_ID), 0, ...
        moviesToInclude, amplitudeValues)
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.99, sprintf('Traces and applicability range for neuron: %d', NEURON_ID), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    neuronStr = num2str(NEURON_ID);
    print([path neuronStr '_range'], '-dpng', '-r150');
    generatePositionDict3(
%     close(f)
end