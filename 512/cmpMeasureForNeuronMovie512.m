function [measureMatrix, artifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix ] = ...
        cmpMeasureForNeuronMovie512(movie, thresholds, samplesLim, algoHandle, measureHandle, recEle, patternNumber)
    %algoHandle algo(traces, threshold)
    %measureHandle measure(avgArtifactsMatrix)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER 
%     clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    [allEleTraces,~,~] = NS_ReadPreprocessedData( ...
        DATA_PATH,DATA_PATH,0,patternNumber, movie, TRACES_NUMBER_LIMIT, EVENT_NUMBER);
    traces = allEleTraces(:, recEle, :);
    thresholdAlgoHandles = {};
    for i = 1:length(thresholds)
        thresholdAlgoHandles{i} = @(traces) algoHandle(traces, thresholds(i));
    end
    [artifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix]  = computeIDsMatrices(traces, thresholdAlgoHandles);
    meanArtifacts = computeMeanArtifacts(traces, artifactIDsMatrix);
%     meanArtifacts = meanArtifacts - repmat(nanmean(meanArtifacts),size(meanArtifacts, 1), 1); %odejmowanie usrednionego artefaktu
    meanArtifacts = meanArtifacts(:, samplesLim(1):samplesLim(2));
    measureMatrix = computeMeasureMat(meanArtifacts, measureHandle);
    
end


function [artifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix] = computeIDsMatrices(traces, algoHandlesVec)
    artifactIDsMatrix = cell(length(algoHandlesVec), 1);
    excludedIDsMatrix = cell(length(algoHandlesVec), 1);
    spikesIDsMatrix = cell(length(algoHandlesVec), 1);
    for i = 1:length(algoHandlesVec)
        algoHandle = algoHandlesVec{i};
        resultStruct = algoHandle(traces);
        artifactIDsMatrix{i} = resultStruct.artifactIDs;
        excludedIDsMatrix{i} = resultStruct.excluded;
        spikesIDsMatrix{i} = resultStruct.spikes;
    end
    
end


function meanArtifacts = computeMeanArtifacts(oneChannelTraces, artifactIDsMatrix)
    oneChannelTraces = squeeze(oneChannelTraces);
    size(oneChannelTraces);
    traceLength = size(oneChannelTraces, 2);
    meanArtifacts = zeros(length(artifactIDsMatrix), traceLength);
    for  i = 1:length(artifactIDsMatrix)
        artifacts = artifactIDsMatrix{i};
        if length(artifacts) == 1
            meanArtifacts(i, :) = oneChannelTraces(artifacts, :);
        else
            meanArtifacts(i, :) = mean(oneChannelTraces(artifacts, :)); % w przypadku gdy nie znajduje artefaktow, wynik jest NaN-em
        end
    end
end
