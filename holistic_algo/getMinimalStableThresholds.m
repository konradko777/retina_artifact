function stableThresholds = getMinimalStableThresholds(measureMatrix, thresholds, similaritydBreachFunc, minimalCluster) %, maxNeighbourDiff, nToFormCluster)
%measureMatrix(array<float>) - square matrix of difference measure between avgArtifacts
%thresholds(vector<float>) - quantization thresholds used when computing avgArtifacts
%maxNeighbourDiff(float) - maximum difference between neighbouring fields
%   in measureMatrix for thresholds to be declared in one cluster
%minimalCluster(int) - minimum n to declare stable cluster
    for i = 1:length(thresholds)
        measureValForThres = [];
        for j = i+1:length(thresholds)
            cellVal = measureMatrix(j, i);
            measureValForThres = [measureValForThres cellVal];
            for k = i:j-1
                if k == i
                    continue
                end
                cellVal = measureMatrix(j, k);
                measureValForThres = [measureValForThres cellVal];
                
            end
        end
        [bestThresIdx, bestThres] = findBestThreshold(measureValForThres, thresholds, i, similaritydBreachFunc);
        if length(bestThresIdx) >= minimalCluster
            stableThresholds = bestThresIdx;
            return
        end
    end
    stableThresholds = [];
end
    


function [bestThresIdx, bestThres] = findBestThreshold(valuesVector, thresholds, startThresholdIdx, similarityBreachFunc)
    nVals = length(valuesVector);
    nThres = length(thresholds);
    lengthDict = createExpectedValLengthDict(nThres);
    for i=fliplr(1:nThres)
        if nVals >= lengthDict(i)
            trimmedVals = valuesVector(1:lengthDict(i));
            if ~similarityBreachFunc(trimmedVals)
                bestThresIdx = startThresholdIdx:startThresholdIdx + i - 1;
                bestThres = thresholds(bestThresIdx);
                return
            end
        end
    end
end

% function trimmedVals = test(valuesVector, thresholds)
%     nVals = length(valuesVector);
%     nThres = length(thresholds);
%     lengthDict = createExpectedValLengthDict(nThres);
%     for i=fliplr(1:nThres)
%         if nVals >= lengthDict(i)
%             trimmedVals = valuesVector(1:lengthDict(i));
%             return
%         end
%     end
% end

function expectedLengthDict = createExpectedValLengthDict(n)
    keys = 1:n;
    vals = zeros(size(keys));
    for i = 1:n
        vals(i) =  getExpectedNOfElements(i);
    end
    expectedLengthDict = containers.Map(keys, vals);


end
function nElements = getExpectedNOfElements(n)
    if n == 1
        nElements = 0;
    else
        nElements = sum(1:n-1);
    end
end
