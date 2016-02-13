function plotAppTracesForNeuronSpike(neuronID, moviesSpikesIDsMatrix, allTraces, movies, ...
    firstMovie, lastMovie, chosenMovie)
    i = 1;
    OFFSET = 30;
    N_OF_TRACES = 50;
    X_LIM = [0 50];
    POSITIONS = generatePositionDict();
    min_y = min(allTraces(:)) - OFFSET;
    max_y = max(allTraces(:)) + OFFSET;
    allTracesIdx = 1:N_OF_TRACES;
    for movie = movies
        ms = subplot('Position', POSITIONS{i});
        set(ms, 'xlim', X_LIM);
        set(ms, 'ylim', [min_y max_y]);
        set(ms, 'xtick', 0:10:50);
        hold on
        traces = squeeze(allTraces(movie, :, :));
        movieSpikes = moviesSpikesIDsMatrix{movie};
        nOfSpikes = length(movieSpikes);
        movieNotSpikes = allTracesIdx;
        movieNotSpikes(movieSpikes) = [];
        if i ~= 19
            set(ms, 'xticklabel', '')
            set(ms, 'yticklabel', '')
        end
            
        if movie <= lastMovie && movie >= firstMovie
            
            plotSelectedTraces(traces, movieSpikes, 'g')
            plotSelectedTraces(traces, movieNotSpikes, 'r')            
            if movie == chosenMovie
                markMovie(min_y, max_y, ms);
            end
            
        else
            plotSelectedTraces(traces, allTracesIdx, 'k')
        end
        plotSpikeNumber(nOfSpikes, 35, max_y - OFFSET);
        i = i + 1;
    end
end

function plotSpikeNumber(spikeNumber, x, y)
    text(x, y, sprintf('SF: %d', spikeNumber));
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