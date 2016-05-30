function [avgArtifacts, avgNonArtifacts] = getMeanArtsAndNonArts(neuronTraces, chosenThresholdsVec, artifactIDsMat, nTrialsForMovie, nMovies)
    avgArtifacts = zeros(nMovies, size(neuronTraces,3));
    avgNonArtifacts = zeros(nMovies, size(neuronTraces,3));
    for movie = 1:nMovies
        movieArtifacts = artifactIDsMat{movie};
        movieThresArtifactIDs = movieArtifacts{chosenThresholdsVec(movie)};
        movieThresNonArtifactIDs = 1:nTrialsForMovie;
        movieThresNonArtifactIDs(movieThresArtifactIDs) = [];
        avgArtifacts(movie, :) = mean(squeeze(neuronTraces(movie,movieThresArtifactIDs,:)));
        avgNonArtifacts(movie, :) = mean(squeeze(neuronTraces(movie,movieThresNonArtifactIDs,:)));
        
    end
end