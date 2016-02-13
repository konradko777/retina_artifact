function [spikesDetectedVec, spikesDetectedIdxVec] = detectSpikesForNeuron(neuronID, movies, fullAlgoArtIDs, stableThresForMovie, spikeDetMarigin, sampleLim)
%spikeDetMArigin - by how much resulting waveform's minimum can differ from
%   neuron amplitude to be still classified as TODO watch out for '-' sign
%   complications, mayby percentwise solution is Better?
    spikesDetectedVec = zeros(size(movies));
    spikesDetectedIdxVec = cell(size(movies));
    neuronSpikeAmpDict = createNeuronSpikeAmpDict();
    for i=1:length(movies)
        movie = movies(i);
        movieArtIDs = fullAlgoArtIDs{i};
        movieStableThresIdx = stableThresForMovie(i);
        if ~movieStableThresIdx
            continue
        end
        thresArtIDs = movieArtIDs{movieStableThresIdx};
        spikeAmplitude = neuronSpikeAmpDict(neuronID);
        traces = getTracesForNeuronMovie(neuronID, movie);
        avgArtifact = getAvgArtifactFromAlgo(traces, thresArtIDs);
        [spikesDetectedVec(i), spikesDetectedLogVec] = detectSpikesForMovie(traces, avgArtifact, spikeAmplitude + spikeDetMarigin, sampleLim);
        spikesDetectedIdxVec{i} = logical2indices(spikesDetectedLogVec);
    end


end

function indices = logical2indices(logVec)
    allIndices = 1:length(logVec);
    indices = allIndices(logVec);
end
