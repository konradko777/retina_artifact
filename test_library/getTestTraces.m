function [ tracesDict ] = getTestTraces(  )

tracesMovieEleDict = createTestTracesDict();
labelKeys = keys(tracesMovieEleDict);
tracesDict = containers.Map;
for label = labelKeys
    movieEle = tracesMovieEleDict(label{1});
    tracesDict(label{1}) = getTraces(movieEle(1), movieEle(2));

end

