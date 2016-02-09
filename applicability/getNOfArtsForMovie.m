function nOfArts = getNOfArtsForMovie(movie, fullArtifactIDsMatrix, stableThresVec)
   nOfArts = length(fullArtifactIDsMatrix{movie}{stableThresVec(movie)});

end