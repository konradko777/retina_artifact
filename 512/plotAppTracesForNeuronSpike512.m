function plotAppTracesForNeuronSpike512(neuronID, moviesSpikesIDsMatrix, fullArtIdxMat, fullSpikeIdxMat, stableThresholdsVec,allTraces, movies, ...
    firstMovie, lastMovie, chosenMovie, thresholds)
    i = 1;
    OFFSET = 30;
    N_OF_TRACES = 50;
    X_LIM = [0 50];
    POSITIONS = generatePositionDict2(4, 8);
    min_y = min(allTraces(:)) - OFFSET;
    max_y = max(allTraces(:)) + OFFSET;
    allTracesIdx = 1:N_OF_TRACES;
    for movie = movies
        stableThresIdx = stableThresholdsVec(i);
        ms = subplot('Position', POSITIONS{i});
        set(ms, 'xlim', X_LIM);
        set(ms, 'ylim', [min_y max_y]);
        set(ms, 'xtick', 0:10:50);
        hold on
        traces = squeeze(allTraces(i, :, :));
        movieSpikes = moviesSpikesIDsMatrix{i};
        movieNotSpikes = allTracesIdx;
        movieNotSpikes(movieSpikes) = [];
        step1Spikes = fullSpikeIdxMat{i}{stableThresIdx};
        step1Arts = fullArtIdxMat{i}{stableThresIdx};
        nOfSpikes = length(movieSpikes);
        
        bothSpikes = intersect(movieSpikes, step1Spikes);
        bothArts = intersect(movieNotSpikes, step1Arts);
        onlyStep2Arts = setdiff(movieNotSpikes,step1Arts);
        onlyStep2Spikes = setdiff(movieSpikes, step1Spikes);
        if i ~= 25
            set(ms, 'xticklabel', '')
            set(ms, 'yticklabel', '')
        end
        plotSelectedTraces(traces, bothSpikes, 'g')
        plotSelectedTraces(traces, onlyStep2Arts, 'm')
        plotSelectedTraces(traces, bothArts, 'r')
        plotSelectedTraces(traces, onlyStep2Spikes, 'c')
        
        if i <= lastMovie && i >= firstMovie
            plotCircle(10, max_y - OFFSET, 'g')
        end
        if i == chosenMovie
                markMovie(min_y, max_y, ms);
        end
        plotSpikeNumber(nOfSpikes, 35, max_y - OFFSET);
        threshold = thresholds(stableThresIdx);
%         plotThreshold(threshold, 35, max_y - 2*OFFSET);
        i = i + 1;
    end
end

function plotCircle(x, y, color)
    plot(x, y, '.', 'color', color, 'MarkerSize', 25);
end

function plotSpikeNumber(spikeNumber, x, y)
    text(x, y, sprintf('SF: %d', spikeNumber));
end

function plotThreshold(threshold, x, y)
    text(x, y, sprintf('SF: %d', threshold));
end


function data = extractDataFromFullMat(mat, movie, stableThresVec)
    data = mat{movie}{stableThresVec(movie)};
end

function markMovie(min_, max_, axesHandle)
    xlims = xlim;
    ylims = ylim;
    x_min = xlims(1);
    x_max = xlims(2);
    width = x_max - x_min;
    height = max_ - min_;
    offset = 0;
    rectangle('Position', [0, min_ - offset, ...
        width + 2*offset height + 3*offset], ...
        'clipping', 'off', 'edgecolor', 'b', 'linewidth', 2);
    set(axesHandle, 'ylim', [min_ max_]);
end