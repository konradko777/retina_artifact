classdef resultInterpreter < handle
    properties
        applicabilityRange
    end
    methods
        function interpreterObj = resultInterpreter(applicabilityRange)
            interpreterObj.applicabilityRange = applicabilityRange;
        end     
        function interpretationVec = ... 
                giveInterpretationVec(interpreterObj, spikeVec)
            fullEffIdx = interpreterObj.findFullEffIdx(spikeVec);
            interpretationVec = ones(size(spikeVec));
            if fullEffIdx ~= Inf
                interpretationVec(fullEffIdx:end) = 0;
            end  
        end      
        function fullEffIdx = findFullEffIdx(interpreterObj, spikeVec)
            spikeMin = interpreterObj.applicabilityRange(1);
            spikeMax = interpreterObj.applicabilityRange(2) ;
            inRange = (spikeVec >= spikeMin) & (spikeVec <=spikeMax);
            firstIdx = find(inRange, 1);
            fullEffIdx = 0;
            if firstIdx
                i = firstIdx;
                while i < length(spikeVec)
                    i = i + 1;
                    if spikeVec(i) < spikeVec(i - 1)
                        fullEffIdx = i;
                        break
                    end
                end
                if fullEffIdx == 0
                    fullEffIdx = Inf;
                end
            else
                fullEffIdx = Inf;
            end
        end
    end
end