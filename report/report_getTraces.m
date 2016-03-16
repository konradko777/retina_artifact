%% slowniki daje odpalenie skryptu report1.m

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
plot(traces(spikeIDs(6), :),'b', 'linewidth', 3)
% plot(traces(spikeIDs(2), :),'m', 'linewidth', 3)
text(15, -344, '1', 'color', 'r', 'fontsize', 30, 'fontweight', 'bold')
text(15, -370, '2', 'color', 'g', 'fontsize', 30, 'fontweight', 'bold')
text(13.5, -392, '3', 'color', 'b', 'fontsize', 30, 'fontweight', 'bold')
% text(13, -410, '4', 'color', 'm', 'fontsize', 30, 'fontweight', 'bold')


%% 1 - 2
one = traces(artIDs(1), :);
two = traces(spikeIDs(3), :);
three = traces(spikeIDs(6), :);
four = traces(spikeIDs(2), :);

hold on
plotOneMinusTwo(one, two, 'r', 'g')
plotOneMinusTwo(three, two, 'b', 'g')
plotOneMinusTwo(two, four, 'g', 'm')

%% outliers

NEURON_ID = 227;
movie = 3;
thresID = 4;
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
    
hold on
plot(traces', 'color', gray)
plot(traces(artIDs(8), :),'g', 'linewidth', 3)
plot(traces(excludedIDs(1), :),'r', 'linewidth', 3)
plot(traces(excludedIDs(2), :),'m', 'linewidth', 3)
text(14.5, -330, '1', 'color', 'r', 'fontsize', 30, 'fontweight', 'bold')
text(16, -347, '2', 'color', 'm', 'fontsize', 30, 'fontweight', 'bold')
text(18, -375, '3', 'color', 'g', 'fontsize', 30, 'fontweight', 'bold')
xlabel('Samples', 'fontsize', 30)
set(gca, 'fontsize', 20)

%% subtracting outliers

one = traces(excludedIDs(1), :);
two = traces(excludedIDs(2), :);
three = traces(artIDs(8), :);
ylim_ = [-30 35];
thres = 20;
hold on
plotOneMinusTwo(one, three, 'r', 'g', thres, ylim_)
plotOneMinusTwo(two, three, 'm', 'g', thres, ylim_)

%% outlier classification

hold on
meanArt = mean(traces(artIDs, :));
notArts = 1:50;
notArts = setdiff(notArts, artIDs);
notArts = setdiff(notArts, excludedIDs);
plotSelectedTraces2(traces, artIDs, 'r', 1.5)
plotSelectedTraces2(traces, excludedIDs, 'b', 1.5)
plotSelectedTraces(traces, notArts, gray)
plot(meanArt, 'g--', 'linewidth', 6)
lh = legend('Artifact-only Candidates', 'Excluded Candidates', 'Model of stimulation artifact');
correctLegend2(lh, 'g')

xlabel('Samples', 'fontsize', 30)
set(gca, 'fontsize', 20)
%% choosing QT all traces movies: 3,5, 15, 19

NEURON_ID = 541;
movie = 11;

gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:30);
thresToConsider = [3, 4, 12, 17];
meanArts = zeros(length(thresToConsider), 30);

for i = 1:length(thresToConsider)
    thresID = thresToConsider(i);
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{thresID};
    meanArts(i,:) = mean(traces(artIDs, :));
end

plot(meanArts')
legend('1','2','3','4');
%% qt choosing plotting different classifications
gray = [.2, .2, .2];
thresID = 3;
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
excludedIDs = excludedDict(NEURON_ID);
excludedIDs = excludedIDs{movie}{thresID};
spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs = spikeIDs{movie};
meanArts = zeros(length(thresToConsider), 30);

for i = 1:length(thresToConsider)
    thresID = thresToConsider(i);
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{thresID};
    meanArts(i,:) = mean(traces(artIDs, :));
end

for i = 1:length(thresToConsider)
    subplot(2,2,i)
    hold on
    thresStr = num2str(THRESHOLDS(thresToConsider(i)));
    title(['QT: ' thresStr], 'fontsize', 20)
    plot(traces', 'color', gray)
    thresID = thresToConsider(i);
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{thresID};
    plot(traces(artIDs, :)','r', 'linewidth', 1)
    plot(meanArts(i,:), 'g--', 'linewidth', 3)
%     set(gca, 'fontsize', 20)
end

%% difference between mean artifacts
twenty = meanArts(1, :);
twentyfive = meanArts(2, :);
sixty = meanArts(3, :);
ninety = meanArts(4, :);
fillColor = transRGB(0, 134, 217);
hold on
plot(twenty(1), 'color', transRGB(255, 76, 59), 'linewidth', 4)
plot(ninety(1), 'color', transRGB(255, 228, 72), 'linewidth', 4)
fill(X,Y, fillColor);
plot(twenty, 'color', transRGB(255, 76, 59), 'linewidth', 4)
plot(ninety, 'color', transRGB(255, 228, 72), 'linewidth', 4)
legend('Mean artifact for QT=20', 'Mean artifact for QT=90')
x = 1:length(twenty);
X = [x fliplr(x)];
Y = [twenty fliplr(ninety)];
set(gca, 'fontsize', 20)
xlabel('Samples', 'fontsize', 30)

%% plot all mean artifacts

twenty = meanArts(1, :);
twentyfive = meanArts(2, :);
sixty = meanArts(3, :);
ninety = meanArts(4, :);
hold on

plot(twenty, 'color', transRGB(0, 0, 0), 'linewidth', 4)
plot(twentyfive, 'color', transRGB(255, 76, 59), 'linewidth', 4)
plot(sixty, 'color', transRGB(0, 134, 217), 'linewidth', 4)
plot(ninety, 'color', transRGB(255, 228, 72), 'linewidth', 4)
ylim([-370, -120])
xlim([1, 30])
set(gca, 'fontsize', 20)
xlabel('Samples', 'fontsize', 30)
legend('Mean artifact for QT=20', 'Mean artifact for QT=25', 'Mean artifact for QT=60', 'Mean artifact for QT=90')
%% difference measure 

measureHandle = @cmpDiffMeasureVec;
measureMatrix = computeMeasureMat(meanArts, measureHandle);
plotMeasureSimpleReport(measureMatrix, [20, 25, 60, 90], [0, 300])

%% difference measure + traces

NEURON_ID = 541;
movie = 11;
thresID = 3;
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
tracesTruncated = traces(:, 1:30);

meanArts = zeros(length(thresToConsider), 30);

for i = 1:length(THRESHOLDS)
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{i};
    meanArts(i,:) = mean(tracesTruncated(artIDs, :));
end
measureHandle = @cmpDiffMeasureVec;
measureMatrix = computeMeasureMat(meanArts, measureHandle);

artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{3};
plotMeasureMatWithArts(traces, artIDs, measureMatrix, 1, THRESHOLDS, [1 30], [0 300])

%%
% 
% artDict = containers.Map(NEURON_IDS, fullArtIdxMatrices);
% spikeDict = containers.Map(NEURON_IDS, fullSpikeIdxMatrices);
% excludedDict = containers.Map(NEURON_IDS, fullExcludedIdxMatrices);
% detectedSpikesDict = containers.Map(NEURON_IDS, fullDetectedSpikesIdxMatrices);
% thresDict = containers.Map(NEURON_IDS, stableThresVectors);
% movieDict = containers.Map(NEURON_IDS, chosenMovies);
% nOfSpikesDetDict = containers.Map(NEURON_IDS, nOfSpikesDetected);