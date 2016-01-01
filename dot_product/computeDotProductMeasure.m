function [measureMatrix, meanArtifacts, artifactIDs] = computeDotProductMeasure(electrodeNumber, patternNumber, movieNumber, thresholds)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER;
    minArtifacts = 5;
    offset = 10:40; %we omit beginning and end of trace when computing dot measure
    
    [DataTraces,ArtifactDataTraces,~] = NS_ReadPreprocessedData( ...
        DATA_PATH,DATA_PATH,0,patternNumber, movieNumber, TRACES_NUMBER_LIMIT, EVENT_NUMBER);
    data = DataTraces(:, electrodeNumber, :);
    active_vec = ones(size(data,1));
    for i = 1:length(thresholds)
        threshold = thresholds(i);
        artifactIDs{i} = mgrEstimateArtifactSignal(data, active_vec, threshold, minArtifacts);
    end
    meanArtifacts = computeMeanArtifacts(data, artifactIDs);
    meanArtifacts = meanArtifacts - repmat(nanmean(meanArtifacts),8,1); %odejmowanie usrednionego artefaktu
    meanArtifacts = meanArtifacts(:, offset); %bierzemy tylko 30 probek
    measureMatrix = computeDotMeasure(meanArtifacts);
%     displayArtifactIDs(artifact_ids)
%     measureMatrix = measureMatrix - nanmean(measureMatrix(:));
%     c = measureMatrix - a;
%     figure
%     plot(meanArtifacts')
%     legend('1', '2', '3', '4', '5', '6', '7', '8')
%     HeatMap(measureMatrix, 'colormap', 'jet')
%     pcolor(measureMatrix - a)
%     colorbar
end


function meanArtifacts = computeMeanArtifacts(oneChannelTraces, artifactIDsMatrix)
    meanArtifacts = zeros(length(artifactIDsMatrix), 70);
    for  i = 1:length(artifactIDsMatrix)
        artifacts = artifactIDsMatrix{i};
        meanArtifacts(i, :) = mean(oneChannelTraces(artifacts, :));
    end
end


function measureMatrix = computeDotMeasure(meanArtifacts)
    N = size(meanArtifacts, 1);
    measureMatrix = zeros(N);
    for i = 1:N
        for j = 1:N
            measureMatrix(i, j) = normalizedDotMeasure(meanArtifacts(i, :), meanArtifacts(j, :));
        end
    end
end

function res = normalizedDotMeasure(vec1, vec2)
    res = dot(vec1,vec2) / sqrt(dot(vec1, vec1) * dot(vec2, vec2));
end

function displayArtifactIDs(artIDsCellArray)
    for i = 1:length(artIDsCellArray)
        fprintf('%d : ', i)
        el = artIDsCellArray{i};
        if isempty(el)
            fprintf('[]\n')
        else
            disp(el)
        end
    end

end
