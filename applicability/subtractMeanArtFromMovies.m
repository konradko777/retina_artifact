function allTracesSubtracted = subtractMeanArtFromMovies(allMovieTraces, fullArtIdxMat, stableThresholdVec, movies, nOfSpikesDetVec)
    allTracesSubtracted = zeros(size(allMovieTraces));
    for i = 1:length(movies)
        movieTraces = squeeze(allMovieTraces(i, : ,:));
        nOfSpikes = nOfSpikesDetVec(i);
        if ismember(nOfSpikes, [-1, -2]) %if proper detection of spikes is not possible, simple mean is subtracted for plotting reasons
            allTracesSubtracted(i, :, :) = movieTraces - repmat(mean(movieTraces), size(movieTraces, 1), 1);
            continue
        else
            movieArtIdx = fullArtIdxMat{i}{stableThresholdVec(i)};
            if length(movieArtIdx) == 1
                meanArt = movieTraces(movieArtIdx, :);
            else
                meanArt = mean(movieTraces(movieArtIdx, :));
            end
        end
        allTracesSubtracted(i, :, :) = movieTraces - repmat(meanArt, size(movieTraces, 1), 1);
    end
end