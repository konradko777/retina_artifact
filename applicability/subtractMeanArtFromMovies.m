function allTracesSubtracted = subtractMeanArtFromMovies(allMovieTraces, fullArtIdxMat, stableThresholdVec, movies)
    allTracesSubtracted = zeros(size(allMovieTraces));
    for i = 1:length(movies)
        movieTraces = squeeze(allMovieTraces(i, : ,:));
        movieArtIdx = fullArtIdxMat{i}{stableThresholdVec(i)};
        if length(movieArtIdx) == 1
            meanArt = movieTraces(movieArtIdx, :);
        else
            meanArt = mean(movieTraces(movieArtIdx, :));
        end
%         stableThresholdVec(movies)
%         size(meanArt)
%         size(movieTraces)
        allTracesSubtracted(i, :, :) = movieTraces - repmat(meanArt, size(movieTraces, 1), 1);
        
    end

end