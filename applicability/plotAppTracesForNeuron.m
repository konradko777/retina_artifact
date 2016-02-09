function plotAppTracesForNeuron(neuronID, fullArtifactIDsMatrix, fullExcludedIDsMatrix, fullSpikesIDsMatrix, stableThresVec, movies, firstMovie, lastMovie, chosenMovie)
    i = 1;
    OFFSET = 30;
    for movie = movies
        ms = subplot(4,6, i);
        hold on
        traces = getTracesForNeuronMovie(neuronID, movie);
        
        min_ = min(traces(:)) - OFFSET;
        max_ = max(traces(:)) + OFFSET;
        if movie <= lastMovie && movie >= firstMovie
            movieArts = extractDataFromFullMat(fullArtifactIDsMatrix, movie, stableThresVec);
            movieSpikes = extractDataFromFullMat(fullSpikesIDsMatrix, movie, stableThresVec);
            plotSelectedTraces(traces, movieSpikes, 'g')
            plotSelectedTraces(traces, movieArts, 'r')
            if movie == chosenMovie
                markMovie(min_, max_, ms);
            end
            
        else
            plotSelectedTraces(traces, 1:50, 'k')
        end
        i = i + 1;
    end


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