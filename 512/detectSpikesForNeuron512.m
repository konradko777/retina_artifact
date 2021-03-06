function [spikesDetectedVec, spikesDetectedIdxVec] = detectSpikesForNeuron512(...
    recordingElectrode, stimElectrode, movies, fullAlgoArtIDs, stableThresForMovie, sampleLim, spikeDetectionThres)
%spikeDetMArigin - by how much resulting waveform's minimum can differ from
%   neuron amplitude to be still classified as TODO watch out for '-' sign
%   complications, mayby percentwise solution is Better?
    spikesDetectedVec = zeros(size(movies));
    spikesDetectedIdxVec = cell(size(movies));
    for i=1:length(movies)
        movie = movies(i);
        movieArtIDs = fullAlgoArtIDs{i};
        movieStableThresIdx = stableThresForMovie(i);
        if isempty(movieArtIDs)
            spikesDetectedVec(i) = -1;
            continue
        elseif ~movieStableThresIdx
            spikesDetectedVec(i) = -2;
            continue
        end
        thresArtIDs = movieArtIDs{movieStableThresIdx};
%         spikeAmplitude = neuronSpikeAmpDict(neuronID);
        traces = getMovieElePatternTraces(movie, recordingElectrode, stimElectrode );
        avgArtifact = getAvgArtifactFromAlgo(traces, thresArtIDs);
        [spikesDetectedVec(i), spikesDetectedLogVec] = detectSpikesForMovie(traces, avgArtifact, spikeDetectionThres, sampleLim);
        spikesDetectedIdxVec{i} = logical2indices(spikesDetectedLogVec);
    end


end

function indices = logical2indices(logVec)
    allIndices = 1:length(logVec);
    indices = allIndices(logVec);
end
