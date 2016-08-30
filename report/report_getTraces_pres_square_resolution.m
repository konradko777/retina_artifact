%% slowniki daje odpalenie skryptu report1.m
report1

%%

global NEURON_ELE_MAP NEURON_REC_ELE_MAP

NEURON_ID = 227;
movie = 3;
thresID = 4;    
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:50);

artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
excludedIDs = excludedDict(NEURON_ID);
excludedIDs = excludedIDs{movie}{thresID};

spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs = spikeIDs{movie};

%% traces black & white
gray = [.3 .3 .3];
plot(traces','color', gray, 'linewidth', 2)
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 16)
xlabel('t[ms]', 'fontsize', 20)
set(gca, 'fontsize', 20)
%% testing - looking for proper traces
hold on
grid on
traceID1 = 21;
traceID2 = 25;
traceID = spikeIDs(2);
set(gca, 'Fontsize', 20)
plot(traces', 'color', gray)
plot(traces(traceID1:traceID2,:)', 'r')
plot(traces(traceID,:)', 'g')

%% 1 2 3 4 5 6 picture
hold on
grid on
set(gca, 'Fontsize', 20)
plot(traces', 'color', gray)
one = traces(artIDs(1), :);
two = traces(artIDs(2), :);
three = traces(spikeIDs(4), :);
four = traces(spikeIDs(2), :);
five = traces(spikeIDs(6), :);
six = traces(23,:);
plot(one,'r', 'linewidth', 3)
plot(two,'b', 'linewidth', 3)
plot(three,'g', 'linewidth', 3)
plot(four ,'m', 'linewidth', 3)
plot(five ,'y', 'linewidth', 3)
plot(six, 'c', 'linewidth', 3)
text(15, -344, '1', 'color', 'r', 'fontsize', 30, 'fontweight', 'bold')
text(13, -370, '2', 'color', 'b', 'fontsize', 30, 'fontweight', 'bold')
text(16, -410, '3', 'color', 'g', 'fontsize', 30, 'fontweight', 'bold')
text(18, -420, '4', 'color', 'm', 'fontsize', 30, 'fontweight', 'bold')
text(38, -400, '6', 'color', 'c', 'fontsize', 30, 'fontweight', 'bold')
text(20, -455, '5', 'color', 'y', 'fontsize', 30, 'fontweight', 'bold')
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)

%% generete subtract all from all plot
allTraces = [one; two; three; four; five; six];
colors = ['r', 'b', 'g', 'm', 'y', 'c'];
titles = {'A', 'B', 'C', 'D', 'E', 'F'};
legends = {{repmat(['Passed'], 6, 1)}, ...
    {repmat(['Passed'], 6, 1)}, ...
    {'Failed', 'Failed', 'Passed', 'Passed', 'Failed', 'Failed'}, ...
    {'Failed', 'Failed', 'Passed', 'Passed', 'Failed', 'Failed'}, ...
    {'Failed', 'Failed', 'Passed', 'Passed', 'Passed', 'Failed'}, ...
    {'Failed', 'Failed', 'Passed', 'Passed', 'Passed', 'Passed'}};
posDict = generatePositionDict3(3, 2, .015, .08);
for i = 1:6
%     subplot('Position', posDict{i})
    if ~any(i == [1, 3])
        continue
    end
    figure
    hold on
    currentTrace = allTraces(i,:); 
    subtractedTraces = allTraces - repmat(currentTrace, 6, 1);
    for j = 1:6
        plot(subtractedTraces(j,:), colors(j), 'linewidth', 3)
        set(gca, 'xlim', [0 50])
    end
    legend(legends{i}, 'Fontsize', 20);
    drawDoubleQT(25, 'k', 7)
    set(gca, 'xtick', 0:10:50)
    set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
    set(gca, 'fontsize', 20)
    xlabel('t[ms]', 'fontsize', 20)
    xlabh = get(gca,'XLabel');
    set(xlabh,'Position', [25 -145 0])
    ylim([-130, 130])
    title(sprintf('%s. Trace %d subtracted', titles{i}, i), 'fontsize', 20)
end
path = 'C:\studia\dane_skrypty_wojtek\ks_functions\report\graph_to_rep';
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 20 25])
% print(gcf, '-dpng', 'test.png')

%% plotting one minus two subtractions (art - spike)
qt = 20;
posDict = generatePositionDict3(1,2, .09, .08);
offset = [0 .01 0 0];
subplot('Position', posDict{1} + offset)
hold on
grid on
plot(one, 'b', 'linewidth', 3)
plot(three, 'g', 'linewidth', 3)
legend('Trace 1', 'Trace 3')
title('Raw Signal', 'fontsize', 20)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca,  'fontsize', 20)
xlabel('t[ms]', 'fontsize', 20)
xlabh = get(gca,'XLabel');
set(xlabh,'Position', [25 -487 0])
subplot('Position', posDict{2} + offset)
plotOneMinusTwo2(one, three, 'b', 'g', qt, [-130 130], [0, 50])
title('Trace 1 - Trace 3', 'fontsize', 20)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca,  'fontsize', 20)
xlabel('t[ms]', 'fontsize', 20)
xlabh = get(gca,'XLabel');
set(xlabh,'Position', [25 -140 0])
line(xlim, [-qt -qt], 'linewidth', 2, 'color', 'k')
text(45, -qt - 8, 'QT', 'fontweight', 'bold', 'fontsize', 30)

%% plotting one minus two subtractions (spike - art)
qt = 20;
posDict = generatePositionDict3(1, 2, .09, .08);
offset = [.01 .01 0 0];
subplot('Position', posDict{1} + offset)
hold on
grid on
plot(one, 'b', 'linewidth', 3)
plot(three, 'g', 'linewidth', 3)
legend('Trace 1', 'Trace 3')
title('Raw Signal', 'fontsize', 20)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca,  'fontsize', 20)
xlabel('t[ms]', 'fontsize', 20)
xlabh = get(gca,'XLabel');
set(xlabh,'Position', [25 -487 0])
subplot('Position', posDict{2} + offset - [0)
plotOneMinusTwo2(three, one, 'g', 'b', qt, [-130 130], [0, 50])
line(xlim, [-qt -qt], 'linewidth', 2, 'color', 'k')
text(45, -qt - 8, 'QT', 'fontweight', 'bold', 'fontsize', 30)
title('Trace 3 - Trace 1', 'fontsize', 20)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca,  'fontsize', 20)
xlabel('t[ms]', 'fontsize', 20)
xlabh = get(gca,'XLabel');
set(xlabh,'Position', [25 -140 0])

 %% 1 - 2
one = traces(artIDs(1), :);
two = traces(spikeIDs(3), :);
three = traces(artIDs(6), :);
four = traces(spikeIDs(2), :);

hold on
% plotOneMinusTwo(one, two, 'r', 'g', 30, [-40 120])
plotOneMinusTwo(one, three, 'b', 'r', 30, [-40 120])
% plotOneMinusTwo(two, four, 'g', 'm', 0)
%% tutaj zrobic wykres z 4 odejmowaniami
posDict = generatePositionDict3(2,2, .015, .08);
firstArg = [two; three; four; one];
secondArg = [one; one; three; three];
firstColor = {'b', 'g', 'm', 'r'};
secondColor = {'r', 'r', 'g', 'g'};
titles = {'2 - 1', '3 - 1', '4 - 3', '1 - 3'};
for i = 1:4
    subplot('position', posDict{i})
    plotOneMinusTwo2(firstArg(i, :), secondArg(i, :), firstColor{i}, secondColor{i}, 0, [-130 130], [0, 50])
    if i < 3
        set(gca, 'xticklabel', '')
    else
        set(gca, 'xtick', 0:10:70)
        set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
        xlabel('t[ms]', 'fontsize', 20)
        xlabh = get(gca,'XLabel');
        set(xlabh,'Position', [25 -140 0])
    end
    if ~mod(i, 2)
        set(gca, 'yticklabel', '')
    end
    set(gca, 'fontsize', 20)
    title(titles{i}, 'fontsize', 25)
end

%% plot gray traces for 1 movie
NEURON_ID = 271;
movie = 10;
thresID = 4;    
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:50);
plot(traces', 'color', gray, 'linewidth', 1.5)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)



%% outliers

NEURON_ID = 227;
movie = 3;
thresID = 4;
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,1:50);

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
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 30)
set(gca, 'fontsize', 20)

%% subtracting outliers

one = traces(excludedIDs(1), :);
two = traces(excludedIDs(2), :);
three = traces(artIDs(8), :);
ylim_ = [-30 35];
xlim_ = [1 50];
thres = 20;
hold on
plotOneMinusTwo(one, three, 'r', 'g', thres, ylim_, xlim_)
plotOneMinusTwo(two, three, 'm', 'g', thres, ylim_, xlim_)
set(gca, 'xtick', [0, 10, 20, 30, 40, 50])
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
ticks = get(gca, 'xticklabel');
ticks(1) = 0;
set(gca, 'xticklabel', ticks)
xlabel('t[ms]', 'fontsize', 25)
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
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 30)
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
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 30)
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
% artIDs = setdiff(artIDs, excluded);
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
        set(gca, 'xtick', 0:10:70)
        xlim([0 70])
        set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
        xlabel('t[ms]', 'fontsize', 20)
        set(gca, 'fontsize', 15)
    end
end






%% choosing QT all traces movies: 3,5, 15, 19

NEURON_ID = 541;
movie = 11;
SAMPLE_LIM = [1 50];
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:,SAMPLE_LIM(1) : SAMPLE_LIM(2));

%% plotting traces 
plot(traces', 'color', gray, 'linewidth', 2)
set(gca, 'fontsize', 20)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 30)

%% plot mean arts

thresToConsider = [3, 4, 12, 15];
meanArts = zeros(length(thresToConsider), SAMPLE_LIM(2));
for i = 1:length(thresToConsider)
    thresID = thresToConsider(i);
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{thresID};
    meanArts(i,:) = mean(traces(artIDs, :));
end

plot(meanArts')
legend('1','2','3','4');
%% qt choosing plotting different classifications REVISED
% do tej sekcji trzeba odpalic report1.m z wiekszymi thresholdami,
% bo inaczej spike'i sa poza zasiegiem
NEURON_ID = 227;
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
movie = 3;
traces = getMovieElePatternTraces(movie, recEle, pattern);
traces = traces(:, 1:50);
chosenTraceID = 3;
gray = [.4, .4, .4];
%% computing mean artifact

thresID = 3;
stableThresID = 5; %% uwazzc jakie thresholdy sa ustawione
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{stableThresID};
excludedIDs = excludedDict(NEURON_ID);
excludedIDs = excludedIDs{movie}{stableThresID};
spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs = spikeIDs{movie};
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{stableThresID};
meanArt = mean(traces(artIDs, 1:50));

%% classification of one trace  with different thresholds
gray = [.4 .4 .4];
posDict = generatePositionDict3(6, 2, .05 , .03);
thresToConsider = [1, 4, 5, 7, 9, 15];
tracesSubtracted = traces - repmat(traces(chosenTraceID, :), 50, 1);
posDictCorrection = [.02 0 -0.04 0];
posDictCorrection2 = [0 .02 0 0];
doublePosDict = generatePositionDict3(2, 1, .04, .04);
for i=1:6
    figure
    subplot('Position', doublePosDict{1})
    hold on
    title(sprintf('Quantization Threshold: %d', THRESHOLDS(thresToConsider(i))), ...
        'Fontsize', 18)
    plot(traces(chosenTraceID, :), 'g', 'linewidth', 2)
    plot(traces(chosenTraceID, :), 'r', 'linewidth', 2)
    plot((traces)', 'color', gray)
    ylim([-500 -250])
    if i == 6
        plot(traces(chosenTraceID, :), 'r', 'linewidth', 2)
    else
        plot(traces(chosenTraceID, :), 'g', 'linewidth', 2)
    end
    set(gca, 'xtick', 0:10:50)
%     set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
%     set(gca, 'fontsize', 16)
%     xlabel('t[ms]', 'fontsize', 18)
%     xlabh = get(gca,'XLabel');
%     set(xlabh,'Position', [25 -535 0])
    set(gca, 'xticklabel', '')
    set(gca, 'fontsize', 17) 
    lh = legend('Declared not artifact', 'Declared artifact');
    set(lh, 'fontsize', 20)
    set(lh, 'location', 'southeast')
    anchor = -360;
    line([15 15], [anchor anchor - THRESHOLDS(thresToConsider(i))], 'color', 'y', ...
        'linewidth', 3)
    xlim([0, 50])
    subplot('Position', doublePosDict{2})
    plot(tracesSubtracted', 'color', gray)
    drawDoubleQT(THRESHOLDS(thresToConsider(i)), 'y', 11);
    xlim([0, 50])
    ylim([-140, 150])
    set(gca, 'xticklabel', '')
    set(gca, 'xtick', 0:10:50)
    set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
    set(gca, 'fontsize', 17)
    xlabel('t[ms]', 'fontsize', 20)
    xlabh = get(gca,'XLabel');
    set(xlabh,'Position', [25 -145 0])
end

path = 'C:\studia\dane_skrypty_wojtek\ks_functions\report\graph_to_rep';
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 25 32])
% print(gcf, '-dpng', 'one_trace_classs.png')
%% six different classifications

meanArts = zeros(length(thresToConsider), SAMPLE_LIM(2));
posDict = generatePositionDict3(2, 3, .035, .04);
posDictCorrection = [.01 0 0 0];
posDictCorrection2 = [0 .02 0 0];
for i = 1:length(thresToConsider)
    thresID = thresToConsider(i);
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{thresID};
    meanArts(i,:) = mean(traces(artIDs, :));
end

for i = 1:length(thresToConsider)
    if i < 4
        subplot('Position', posDict{i} + posDictCorrection + posDictCorrection2)
    else
        subplot('Position', posDict{i} + posDictCorrection)
    end
    hold on
    thresStr = num2str(THRESHOLDS(thresToConsider(i)));
    title(['Quantization Threshold: ' thresStr], 'fontsize', 20)
    plot(traces', 'color', gray)
    thresID = thresToConsider(i);
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{thresID};
    plot(traces(artIDs, :)','r', 'linewidth', 1)
    plot(meanArts(i,:), 'g--', 'linewidth', 3)
    set(gca, 'fontsize', 20)
    xlim([0, 50])
    if i ~= 4
        set(gca, 'xticklabel', '')
        set(gca, 'yticklabel', '')
    else
        set(gca, 'xtick', 0:10:50)
        set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
        set(gca, 'fontsize', 16)
        xlabel('t[ms]', 'fontsize', 18)
        xlabh = get(gca,'XLabel');
        set(xlabh,'Position', [25 -520 0])
    end
    set(gca, 'fontsize', 20)
end
path = 'C:\studia\dane_skrypty_wojtek\ks_functions\report\graph_to_rep';
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 20 30])
print(gcf, '-dpng', '6QT_classifications.png')

%% plot 1 classification
gray = [.2, .2, .2];
thresID = 3;
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
excludedIDs = excludedDict(NEURON_ID);
excludedIDs = excludedIDs{movie}{thresID};
spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs = spikeIDs{movie};
meanArts = zeros(length(thresToConsider), SAMPLE_LIM(2));

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
twenty = meanArts(2, :);
twentyfive = meanArts(2, :);
% sixty = meanArts(3, :);
ninety = meanArts(6, :);
twenty_ninety = ninety - twenty;
fillColor = transRGB(0, 134, 217);
x = 1:length(twenty);
X = [x fliplr(x)];
Y = [twenty fliplr(ninety)];
subplot(2,1,1)
hold on
grid on
title('Mean artifacts', 'fontsize', 20)
plot(twenty(1), 'color', transRGB(255, 76, 59), 'linewidth', 4)
plot(ninety(1), 'color', transRGB(255, 228, 72), 'linewidth', 4)
set(gca, 'fontsize', 20)
set(gca, 'xticklabels', '')
fill(X,Y, fillColor);
title('Stimulation Artifact Estimates', 'fontsize', 20)
plot(twenty, 'color', transRGB(255, 76, 59), 'linewidth', 4)
plot(ninety, 'color', 'g', 'linewidth', 4)
legend('Mean artifact for QT=10', 'Mean artifact for QT=120')

subplot(2, 1, 2)
hold on
grid on
x = 1:length(twenty);
X = [x fliplr(x)];
Y = [zeros(size(twenty)) fliplr(twenty_ninety)];
fill(X,Y, fillColor);
title('Estimate for QT=10 subtracted', 'fontsize', 20)
plot(zeros(size(twenty)), 'color', transRGB(255, 76, 59), 'linewidth', 4)
plot(twenty_ninety, 'color', 'g', 'linewidth', 4)

set(gca, 'fontsize', 20)
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 30)

%% plot all mean artifacts

twenty = meanArts(1, :);
twentyfive = meanArts(2, :);
sixty = meanArts(3, :);
ninety = meanArts(4, :);
LINEWIDTH = 3;
hold on
legends = arrayfun(@(x) sprintf('Mean artifact for QT = %d', x), ...
    THRESHOLDS(thresToConsider), 'UniformOutput', false);
plot(meanArts(1, :), 'color', transRGB(0, 0, 0), 'linewidth', LINEWIDTH)
plot(meanArts(2, :), 'color', transRGB(255, 76, 59), 'linewidth', LINEWIDTH)
plot(meanArts(3, :), 'color', transRGB(0, 134, 217), 'linewidth', LINEWIDTH)
plot(meanArts(4, :), 'color', transRGB(255, 228, 72), 'linewidth', LINEWIDTH)
plot(meanArts(5, :), 'color', 'm', 'linewidth', LINEWIDTH)
plot(meanArts(6, :), 'color', 'g', 'linewidth', LINEWIDTH)
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
ylim([-380, -270])
% xlim([1, 30])
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)
legend(legends)
%% difference measure 

figure()
% set(gcf, 'InvertHardCopy', 'off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
measureHandle = @cmpDiffMeasureVec;
measureMatrix = computeMeasureMat(meanArts, measureHandle);
plotMeasureSimpleReport(measureMatrix, -10, THRESHOLDS(thresToConsider), [0, 300])
print(gcf, '-dpng', 'C:/studia/dane_skrypty_wojtek/prezentacja_lipiec/graph/diffrence_matrix_traces.png')
% saveas(1, 'small_measure_mat_rep_poprawione.png')
%% difference measure + traces

% NEURON_ID = 541;
% movie = 11;
% thresID = 3;

NEURON_ID = 227;
movie = 3;


gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
tracesTruncated = traces(:, 1:30);

meanArts = zeros(length(THRESHOLDS), 30);

for i = 1:length(THRESHOLDS)
    artIDs = artDict(NEURON_ID);
    artIDs = artIDs{movie}{i};
    meanArts(i,:) = mean(tracesTruncated(artIDs, :));
end
measureHandle = @cmpDiffMeasureVec;
measureMatrix = computeMeasureMat(meanArts, measureHandle);

thresID1 = 4;
thresID2 = 15;
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID1};
artIDs2 = artDict(NEURON_ID);
artIDs2 = artIDs2{movie}{thresID2};
thresLineCoord = [13.5, -360];
plotMeasureMatWithArts3(traces, artIDs, artIDs2, measureMatrix, thresID1, ...
    thresID2, THRESHOLDS, [1 30], [0 70], thresLineCoord, thresLineCoord, [-15 6])
path = 'C:\studia\dane_skrypty_wojtek\ks_functions\report\graph_to_rep';
set(gcf, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 40 20])
print(gcf, '-dpng', 'diffrence_matrix_traces.png')
%% plot classification with small thres
NEURON_ID = 227;
movie = 2;
thresID = 2;

gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);

artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};

hold on
plot(traces(artIDs,:)', 'color', 'r', 'linewidth', 2)
plot(traces', 'color', gray, 'linewidth', 2)
plot(traces(artIDs,:)', 'color', 'r', 'linewidth', 2)
legend('Artifact candidates')
set(gca, 'fontsize', 20)
set(gca, 'xtick', 0:10:70)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 20)

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

%% banana plot 
NEURON_ID = 391;
movie = 11;
thresIDvec = thresDict(NEURON_ID);
thresID = 1;%thresIDvec(movie);
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
% traces = traces(:,1:30);
% 
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs  = spikeIDs {movie};
spikeIDs = setdiff(spikeIDs, 15);
% meanArt = mean(traces(artIDs, :));
% tracesSubtracted = traces - replicateVector(meanArt, traces);
% hold on
% plot(traces', 'k')
% plot(traces(artIDs,:)', 'r', 'linewidth', 2)
% plot(traces(spikeIDs, :)', 'g', 'linewidth', 2)


% 15 spike odstaj?cy
% 9 spike
% 20 art
% for i = 20:20
%     figure
%     hold on
%     plot(traces', 'k')
%     plot(traces(i,:), 'r', 'linewidth', 2)
%     
% end
artID = 20;
spikeID = 9;
minusArt = traces - replicateVector(traces(artID, :), traces);  
minusSpike = traces - replicateVector(traces(spikeID, :), traces);  
figure
hold on
plot(minusSpike(spikeIDs, :)', 'g')
plot(minusSpike(artIDs, :)', 'r')
ylim([-100 100])

figure
hold on
plot(minusArt(spikeIDs, :)', 'g')
plot(minusArt(artIDs, :)', 'r')
ylim([-100 100])


%% banana plot 650, z zestawu dany 00
addJava
setGlobals512_00
load 512_00_all_vars

NEURON_ID = 650;
movie = 17;
thresIDvec = thresDict(NEURON_ID);
thresID = thresIDvec(movie);
gray = [.3, .3, .3];
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie * 2 - 1, recEle, pattern);
traces = traces(:, 1:50);
artIDs = artDict(NEURON_ID);
artIDs = artIDs{movie}{thresID};
spikeIDs = detectedSpikesDict(NEURON_ID);
spikeIDs  = spikeIDs {movie};

% 8 art
% 6 spike
% for i = 6
%     figure
%     hold on
%     plot(traces', 'k')
%     plot(traces(i,:), 'r', 'linewidth', 2)
%     
% end

artID = 8;
spikeID = 6;
minusArt = traces - replicateVector(traces(artID, :), traces);  
minusSpike = traces - replicateVector(traces(spikeID, :), traces);  
%% plotting classification
hold on
gray = [.3 .3 .3];
plot(traces(artIDs,:)', 'r', 'linewidth', 2)
plot(traces(spikeIDs, :)', 'color', gray, 'linewidth', 2)
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 20)
set(gca, 'fontsize', 20)

%% plotting spike detection 

hold on
gray = [.3 .3 .3];
traces = traces - replicateVector(mean(traces(artIDs, :)), traces);
plot(traces(spikeIDs,:)', 'g', 'linewidth', 2)
plot(traces(artIDs, :)', 'color', gray, 'linewidth', 2)
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 20)
line(xlim, [-150 -150], 'linewidth', 2, 'color', 'b')
set(gca, 'fontsize', 20)
legend('Detected spikes')
%% only plot
traceSize = size(traces(1,:));
subplot(2,2, 1)
hold on
plot(traces', 'k')
plot(traces(artID,:), 'r', 'linewidth', 4, 'linestyle', '--')

set(gca, 'xticklabel', '')
set(gca, 'fontsize', 20)
title('                                                                             Artifact Candidate', 'fontsize', 25)


subplot(2,2, 2)
hold on
plot(minusArt', 'k')
plot(zeros(traceSize), 'color', 'r', 'linewidth', 4, 'linestyle', '--') 
set(gca, 'xticklabel', '')
set(gca, 'fontsize', 20)
ylim([-300 300])

subplot(2,2, 3)
hold on

plot(traces', 'k')
plot(traces(spikeID,:), 'r', 'linewidth', 4, 'linestyle', '--')
set(gca, 'xticklabel', '')
set(gca, 'fontsize', 20)
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 20)
title('                                                                            Declared not artifact', 'fontsize', 25)



subplot(2,2, 4)
hold on
plot(minusSpike', 'k')
plot(zeros(traceSize), 'color', 'r', 'linewidth', 4, 'linestyle', '--')
set(gca, 'fontsize', 20)

line([0 50], [50 50], 'linewidth', 3, 'color', 'y')
text(47, 80, 'QT', 'fontsize', 25)
ylim([-300 300])
set(gca, 'xtick', 0:10:50)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
xlabel('t[ms]', 'fontsize', 20)

% figure
% hold on
% plot(minusSpike', 'k')
% plot(minusArt', 'k')
% plot(minusSpike(spikeIDs, :)', 'g')
% plot(minusSpike(artIDs, :)', 'r')
% ylim([-250 250])
% 
% figure
% hold on
% plot(minusArt(spikeIDs, :)', 'g')
% plot(minusArt(artIDs, :)', 'r')
% ylim([-250 250])
% 
% % 
% % 
% hold on
% plot(traces', 'k')
% plot(traces(artIDs,:)', 'r', 'linewidth', 2)
% plot(traces(spikeIDs, :)', 'g', 'linewidth', 2)
% 
% 
%%
% 
% artDict = containers.Map(NEURON_IDS, fullArtIdxMatrices);
% spikeDict = containers.Map(NEURON_IDS, fullSpikeIdxMatrices);
% excludedDict = containers.Map(NEURON_IDS, fullExcludedIdxMatrices);
% detectedSpikesDict = containers.Map(NEURON_IDS, fullDetectedSpikesIdxMatrices);
% thresDict = containers.Map(NEURON_IDS, stableThresVectors);
% movieDict = containers.Map(NEURON_IDS, chosenMovies);
% nOfSpikesDetDict = containers.Map(NEURON_IDS, nOfSpikesDetected);