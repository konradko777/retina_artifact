%% slowniki daje odpalenie skryptu report1.m

global NEURON_ELE_MAP NEURON_REC_ELE_MAP

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


%% plot gray traces for 1 movie
NEURON_ID = 271;
movie = 10;
thresID = 4;    
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:30);

plot(traces', 'color', gray, 'linewidth', 1.5)
xlabel('Samples', 'fontsize', 30)
%% 1 2 3 picture
hold on
grid on
set(gca, 'Fontsize', 20)

plot(traces', 'color', gray)
plot(traces(artIDs(1), :),'r', 'linewidth', 3)
plot(traces(spikeIDs(3), :),'g', 'linewidth', 3)
plot(traces(artIDs(6), :),'b', 'linewidth', 3)
% plot(traces(spikeIDs(2), :),'m', 'linewidth', 3)
text(15, -344, '1', 'color', 'r', 'fontsize', 30, 'fontweight', 'bold')
text(15, -410, '2', 'color', 'g', 'fontsize', 30, 'fontweight', 'bold')
text(13, -370, '3', 'color', 'b', 'fontsize', 30, 'fontweight', 'bold')
% text(13, -410, '4', 'color', 'm', 'fontsize', 30, 'fontweight', 'bold')
xlabel('Samples', 'fontsize', 30)


%% 1 - 2
one = traces(artIDs(1), :);
two = traces(spikeIDs(3), :);
three = traces(artIDs(6), :);
four = traces(spikeIDs(2), :);

hold on
% plotOneMinusTwo(one, two, 'r', 'g', 30, [-40 120])
plotOneMinusTwo(one, three, 'b', 'r', 30, [-40 120])
% plotOneMinusTwo(two, four, 'g', 'm', 0)

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
grid on
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


%% class with outliers + mean

hold on
meanArtCand = mean(traces([artIDs excludedIDs], :));
meanArt = mean(traces(artIDs, :));
notArts = 1:50;
notArts = setdiff(notArts, artIDs);
notArts = setdiff(notArts, excludedIDs);
plotSelectedTraces2(traces, artIDs, 'r', 1.5)
plotSelectedTraces2(traces, excludedIDs, 'r', 1.5)
plotSelectedTraces(traces, notArts, gray)
plot(meanArtCand, 'g--', 'linewidth', 6)
% plot(meanArt, 'g--', 'linewidth', 2)
lh = legend('Artifact-only Candidates', 'Mean artifact-only candidate');
correctLegend3(lh, 2, 'g', '--')

xlabel('Samples', 'fontsize', 30)
set(gca, 'fontsize', 20)


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


%% plot 1 artifact classification 

NEURON_ID = 227;
movie = 2;
thresID = 2;
% excluded = [16, 49]; %% watch out!!!

gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
tracesTruncated = traces(:, 1:30);

artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
excludedIDs = excludedDict(NEURON_ID);
excludedIDs = excludedIDs{movie}{thresID}

spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs = spikeIDs{movie};

hold on
meanArt = mean(traces(artIDs, :));
notArts = 1:50;
notArts = setdiff(notArts, artIDs);
% notArts = setdiff(notArts, excludedIDs);
artIDs = setdiff(artIDs, excluded);
plotSelectedTraces2(traces, artIDs, 'r', 1.5)
% plotSelectedTraces2(traces, excludedIDs, 'b', 1.5)
plotSelectedTraces(traces, notArts, gray)
plot(meanArt, 'g--', 'linewidth', 6)
lh = legend('Artifacts', 'Artifact model');
correctLegend3(lh, 2, 'g', '--')

xlabel('Samples', 'fontsize', 30)
set(gca, 'fontsize', 20)

%% plot 3 movie traces

NEURON_ID = 271;
movie = 8;



gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);


movies = [1,3, 8, 12, 15, 20];
i = 0;
positions = generatePositionDict2(2,3);
for movie = movies
    i = i + 1;
    subplot('position', positions{i})
    traces = getMovieElePatternTraces(movie, recEle, pattern);
    plotSelectedTraces2(traces, 1:50, gray, 1)
    ylim([-550 -200])
    if i ~= 4
        set(gca, 'xticklabel', '')
        set(gca, 'yticklabel', '')
    else
        xlabel('Samples', 'fontsize', 15)
        set(gca, 'fontsize', 15)
    end
end






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

%% plot 1 classification
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

i=1;
hold on
thresStr = num2str(THRESHOLDS(thresToConsider(i)));
title(['QT: ' thresStr], 'fontsize', 20)
plot(traces', 'color', gray)
thresID = thresToConsider(i);
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
plot(traces(artIDs, :)','r', 'linewidth', 2)
% plot(meanArts(i,:), 'g--', 'linewidth', 3)

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
plotMeasureSimpleReport(measureMatrix, -10, [20, 25, 60, 90], [0, 300])

%% difference measure + traces

% NEURON_ID = 541;
% movie = 11;
% thresID = 3;

NEURON_ID = 227;
movie = 2;
thresID = 12;


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

thresID = 17;
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
plotMeasureMatWithArts(traces, artIDs, measureMatrix, thresID, THRESHOLDS, [1 30], [0 100])
%% difference measure + traces tylko do prezentacji (inna THRESHOLDS) inny neuron
NEURON_ID = 227;
movie = 2;
thresID = 10;


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
artIDs = artIDs{movie}{thresID};
plotMeasureMatWithArts(traces, artIDs, measureMatrix, thresID, THRESHOLDS, [1 30], [0 100])




%% spike detection 

global NEURON_ELE_MAP NEURON_REC_ELE_MAP

NEURON_ID = 541;
movie = 11;
thresID = 3;
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:30);

artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
meanArt = mean(traces(artIDs, :));

tracesSubtracted = traces %traces - repmat(meanArt, size(traces, 1), 1);
[spikeCound, spikeIDs] = detectSpikesForMovie(traces, meanArt, -80, [11:40]);
SDT = -80;
hold on
grid on
plot(tracesSubtracted(spikeIDs(i), 1)','g', 'linewidth', 2)
plot(tracesSubtracted', 'color', gray)
plot(tracesSubtracted(spikeIDs, :)','g', 'linewidth', 2)
line(xlim, [SDT SDT], 'color', 'b', 'linewidth', 2)
text(28, SDT + 5, 'SDT', 'fontsize', 20, 'fontweight', 'bold')
legend('Detected spikes', 'location', 'southeast')
set(gca, 'fontsize', 20)
xlabel('Samples', 'fontsize', 30)


%% chosing best movie

NEURON_ID = 541;
allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
nOfSpikesVec = nOfSpikesDetDict(NEURON_ID);
plot(nOfSpikesVec, 'b.-','linewidth', 2, 'markersize', 30)
set(gca, 'XTick', [1:24])
set(gca, 'fontsize', 20)
xlabel('Stim Current Amplitude', 'fontsize', 30)
ylabel('Spikes Detected', 'fontsize', 30)
xlim([1 24])
ylim([0 50])
% allTracesSubtracted = subtractMeanArtFromMovies(allTraces, artDict(NEURON_ID), thresDict(NEURON_ID), MOVIES, nOfSpikesVec);
% 
% plotAppTracesForNeuronSpike512(NEURON_ID, detectedSpikesDict(NEURON_ID), artDict(NEURON_ID), ...
%     spikeDict(NEURON_ID), thresDict(NEURON_ID), allTraces, MOVIES, 0, 24,...
%     movieDict(NEURON_ID), THRESHOLDS, nOfSpikesVec, 0, 0, 50)

%% plot artifact classification for given movie
NEURON_ID = 271;
movie = 22;
thresIDvec = thresDict(NEURON_ID);
thresID = thresIDvec(movie);
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:30);
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
meanArt = mean(traces(artIDs, :));
tracesSubtracted = traces - replicateVector(meanArt, traces);

subplot(1,2,1)
hold on
title('Raw signal', 'fontsize', 20)
plot(traces(artIDs(i), 1)','r', 'linewidth', 2)
plot(traces', 'color', gray)
plot(traces(artIDs, :)','r', 'linewidth', 2)
plot(meanArt, 'g--', 'linewidth', 4)
xlabel('Samples', 'fontsize', 30)
set(gca, 'fontsize', 20)
legend('Artifact Candidates')
subplot(1,2,2)
hold on
% plot(traces(artIDs(i), 1)','g', 'linewidth', 2)
title('Artifact subtracted', 'fontsize', 20)
plot(tracesSubtracted', 'color', gray)
plot(tracesSubtracted(artIDs, :)','r', 'linewidth', 2)
plot(zeros(size(meanArt)), 'g--', 'linewidth', 4)
line(xlim, [-40 -40], 'linewidth', 4)
text(27, -37, 'SDT', 'fontsize', 20)
ylim([-50 20])
xlabel('Samples', 'fontsize', 30)
set(gca, 'fontsize', 20)

%% shade efficiency function

NEURON_ID = 541;
allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
nOfSpikesVec = nOfSpikesDetDict(NEURON_ID);
hold on
X = [9 9 11 11];
Y = [0 50 50 0];
patch(X,Y, 'g', 'FaceAlpha',.3)
plot(nOfSpikesVec, 'b.-','linewidth', 2, 'markersize', 30)
set(gca, 'XTick', [1:24])
set(gca, 'fontsize', 20)
xlabel('Stim Current Amplitude', 'fontsize', 30)
ylabel('Spikes Detected', 'fontsize', 30)
legend('Applicability range')
xlim([1 24])
ylim([0 50])


%% choosing movie plot
NEURON_ID = 541;
allTraces = getTracesForNeuron(NEURON_ID, MOVIES);
nOfSpikesVec = nOfSpikesDetDict(NEURON_ID);
subplot(1,2,1)
hold on
X = [9 9 11 11];
Y = [0 50 50 0];
xlim([1 24])
ylim([0 50])
patch(X,Y, 'g', 'FaceAlpha',.3)
% rectangle('position', [10, -1, 2, 2],'clipping', 'off', 'linewidth', 2, 'edgecolor', 'r')
plot(nOfSpikesVec, 'b.-','linewidth', 2, 'markersize', 30)
set(gca, 'XTick', [1:24])
set(gca, 'fontsize', 15)
xlabel('Stim Current Amplitude', 'fontsize', 30)
ylabel('Spikes Detected', 'fontsize', 30)
legend('Applicability range')
title('A. 50% stimulation efficiency current', 'fontsize', 30)



subplot(1,2,2)
hold on
X = [9 9 11 11];
Y = [0 50 50 0];
patch(X,Y, 'g', 'FaceAlpha',.3)
plot(nOfSpikesVec, 'b.-','linewidth', 2, 'markersize', 30)
set(gca, 'XTick', [1:24])
set(gca, 'fontsize', 15)
xlabel('Stim Current Amplitude', 'fontsize', 30)
% ylabel('Spikes Detected', 'fontsize', 30)
xlim([1 24])
ylim([0 50])
title('B. 100% stimulation efficiency current', 'fontsize', 30)



%%
% 
% artDict = containers.Map(NEURON_IDS, fullArtIdxMatrices);
% spikeDict = containers.Map(NEURON_IDS, fullSpikeIdxMatrices);
% excludedDict = containers.Map(NEURON_IDS, fullExcludedIdxMatrices);
% detectedSpikesDict = containers.Map(NEURON_IDS, fullDetectedSpikesIdxMatrices);
% thresDict = containers.Map(NEURON_IDS, stableThresVectors);
% movieDict = containers.Map(NEURON_IDS, chosenMovies);
% nOfSpikesDetDict = containers.Map(NEURON_IDS, nOfSpikesDetected);