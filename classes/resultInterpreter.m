classdef resultInterpreter < handle
% A class designed to review results obtained with artClassifier object and
% tell at what point 100% efficacy was reached and as a result neural spike
% was included in stimulation artifact estimate.
    properties
        applicabilityRange
    end
    methods
        function interpreterObj = resultInterpreter(applicabilityRange)
        % Class constructor. 
        % Input:
        %     applicbilityRange(Vector<Int>): a two element vector stating
        %         minimal and maximal amount of spikes detected. At least
        %         one amplitude needs result in n spikes of neuron, such
        %         that applicabilityRange(1) <= n <= applicabilityRange(2)
            interpreterObj.applicabilityRange = applicabilityRange;
        end     
        function interpretationVec = ... 
                giveInterpretationVec(interpreterObj, spikeVec)
        % Method returns binary vector where 1s means that stimulation
        % artifacts were properly estimated for theses amplitudes, while
        % neural spike shape is added to estimates for amplitudes where
        % interpretationVec == 0.
        % Input:
        %     spikeVec(Vector<Int>): vector that conveys information about
        %         how many spike were detected for consecutive amplitudes.
        % Output:
        %     interpretationVec(Vector<Boolean>): 1s state that artifact
        %         was properly estimated, 0s that neural spike is linearly
        %         added on top of the stimulation artifact as a result of
        %         100% stimulation efficacy
            fullEffIdx = interpreterObj.findFullEffIdx(spikeVec);
            interpretationVec = ones(size(spikeVec));
            if fullEffIdx ~= Inf
                interpretationVec(fullEffIdx:end) = 0;
            end  
        end      
        function fullEffIdx = findFullEffIdx(interpreterObj, spikeVec)
        % Index of amplitude that led to 100% stimulation efficacy. If no
        % such amplitude found Inf is returned.
        % Input:
        %     spikeVec(Vector<Int>): vector that conveys information about
        %         how many spike were detected for consecutive amplitudes.
        % Output:
        %     fullEffIdx(Int): Index of amplitude that led to 100% 
        %         stimulation efficacy. If no such amplitude found Inf 
        %         is returned.

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