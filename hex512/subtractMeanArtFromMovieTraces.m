function subtractedTraces = subtractMeanArtFromMovieTraces(traces, artIDs)
    if length(artIDs) == 1
        meanArt = traces(artIDs, :);
    else
        meanArt = mean(traces(artIDs, :));
    end
    subtractedTraces = traces - repmat(meanArt, size(traces,1), 1);

end