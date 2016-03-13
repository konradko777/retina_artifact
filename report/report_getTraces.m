global NEURON_ELE_MAP NEURON_REC_ELE_MAP

NEURON_ID = 76;
movie = 5;
thresID = 3;
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:30);

artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
excludedIDs = excludedDict(NEURON_ID);
excludedIDs = excludedIDs{movie}{thresID};

spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs = spikeIDs{movie};


%% 1 2 3 picture
hold on
grid on
plot(traces', 'color', gray)
plot(traces(artIDs(1), :),'r', 'linewidth', 3)
plot(traces(spikeIDs(3), :),'g', 'linewidth', 3)
plot(traces(spikeIDs(5), :),'b', 'linewidth', 3)
plot(traces(spikeIDs(2), :),'m', 'linewidth', 3)
text(15, -344, '1', 'color', 'r', 'fontsize', 30, 'fontweight', 'bold')
text(15, -370, '2', 'color', 'g', 'fontsize', 30, 'fontweight', 'bold')
text(13.5, -392, '3', 'color', 'b', 'fontsize', 30, 'fontweight', 'bold')
text(13, -410, '4', 'color', 'm', 'fontsize', 30, 'fontweight', 'bold')
plotSelectedTraces(traces, spikeIDs(3) , 'c')
plotSelectedTraces(traces, spikeIDs(5) , 'g')


plot(traces(spikeIDs(5), :),'m', 'linewidth', 2)

%% 1 - 2
one = traces(artIDs(1), :);
two = traces(spikeIDs(3), :);
three = traces(spikeIDs(5), :);
four = traces(spikeIDs(2), :);

hold on
plotOneMinusTwo(one, two, 'r', 'g')
plotOneMinusTwo(three, two, 'b', 'g')
plotOneMinusTwo(two, four, 'g', 'm')

%%

% 
% artDict = containers.Map(NEURON_IDS, fullArtIdxMatrices);
% spikeDict = containers.Map(NEURON_IDS, fullSpikeIdxMatrices);
% excludedDict = containers.Map(NEURON_IDS, fullExcludedIdxMatrices);
% detectedSpikesDict = containers.Map(NEURON_IDS, fullDetectedSpikesIdxMatrices);
% thresDict = containers.Map(NEURON_IDS, stableThresVectors);
% movieDict = containers.Map(NEURON_IDS, chosenMovies);
% nOfSpikesDetDict = containers.Map(NEURON_IDS, nOfSpikesDetected);