function [ normDotMatrix, rawDotMatrix, artifactIDsMatrix ] = cmpDotForNeuronMovieStruct(neuronID, algoHandle, movie, thresholds, samplesLim)

%[mergedMeasureMatrix, meanArtifacts, artifactIDs] = computeDotProductMeasure(electrodeNumber, patternNumber, movieNumber, thresholds)
    %algoHandle algo(traces, threshold)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER 
    global NEURON_REC_ELE_MAP NEURON_ELE_MAP NEURON_CLUST_FILE_MAP
    recEle = NEURON_REC_ELE_MAP(neuronID);
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    [allEleTraces,~,~] = NS_ReadPreprocessedData( ...
        DATA_PATH,DATA_PATH,0,patternNumber, movie, TRACES_NUMBER_LIMIT, EVENT_NUMBER);
    traces = allEleTraces(:, recEle, :);
    thresholdAlgoHandles = {};
    for i = 1:length(thresholds)
        thresholdAlgoHandles{i} = @(traces) algoHandle(traces, thresholds(i));
    end
    artifactIDsMatrix = computeArtifactIDsMatrix(traces, thresholdAlgoHandles);
    meanArtifacts = computeMeanArtifacts(traces, artifactIDsMatrix);
    meanArtifacts = meanArtifacts - repmat(nanmean(meanArtifacts),size(meanArtifacts, 1), 1); %odejmowanie usrednionego artefaktu
    meanArtifacts = meanArtifacts(:, samplesLim(1):samplesLim(2));
    [normDotMatrix, rawDotMatrix] = computeDotMeasure(meanArtifacts);
    
end


function artifactIDsMatrix = computeArtifactIDsMatrix(traces, algoHandlesVec)
    artifactIDsMatrix = cell(length(algoHandlesVec), 1);
    for i = 1:length(algoHandlesVec)
        algoHandle = algoHandlesVec{i};
        resultStruct = algoHandle(traces);
        artifactIDsMatrix{i} = resultStruct.artifactIDs;
    end
    
end


function meanArtifacts = computeMeanArtifacts(oneChannelTraces, artifactIDsMatrix)
    meanArtifacts = zeros(length(artifactIDsMatrix), 70);
    for  i = 1:length(artifactIDsMatrix)
        artifacts = artifactIDsMatrix{i};
        meanArtifacts(i, :) = mean(oneChannelTraces(artifacts, :));
    end
end


function [normed, raw] = computeDotMeasure(meanArtifacts)
    N = size(meanArtifacts, 1);
    normed = zeros(N);
    raw = zeros(N);
    for i = 1:N
        for j = 1:N
            normed(i, j) = normalizedDotMeasure(meanArtifacts(i, :), meanArtifacts(j, :));
            raw(i,j) = dot(meanArtifacts(i, :), meanArtifacts(j, :));
        end
    end
end
