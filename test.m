function [bestThresIdx, bestThres] = test(valuesVector, thresholds, startThresholdIdx, similarityBreachFunc)
    nVals = length(valuesVector);
    nThres = length(thresholds);
    lengthDict = createExpectedValLengthDict(nThres);
    for i=fliplr(1:nThres)
        if nVals >= lengthDict(i)
            trimmedVals = valuesVector(1:lengthDict(i));
            if ~similarityBreachFunc(trimmedVals)
                bestThresIdx = startThresholdIdx:i;
                bestThres = thresholds(bestThresIdx);
                return
            end
        end
    end
end


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