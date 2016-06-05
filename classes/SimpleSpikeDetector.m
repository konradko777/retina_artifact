classdef SimpleSpikeDetector < handle
    properties
        samplesOfInterest
    end
    
    methods
        function detectorObj = SimpleSpikeDetector(samplesOfInterest)
            detectorObj.samplesOfInterest = samplesOfInterest;
            
        end
        
        function [spikeDetected, halfMaxIdx] = detectSpike(detectorObj, trace, artifact, threshold)
            halfMaxIdx = 0;
            subtracted = trace - artifact;
            truncated = subtracted(detectorObj.samplesOfInterest(1):....
                detectorObj.samplesOfInterest(2));
            [minValue, minIdx] = min(truncated); 
            spikeDetected = minValue <= threshold;
            i = minIdx;
            if spikeDetected
                while i > 0
                    if truncated(i) > (minValue / 2);
                        break
                    end
                    i = i - 1;
                end
                halfMaxIdx = i + detectorObj.samplesOfInterest(1);
            end
        end
        function [spikesDetectedMat] = detectSpikesForMovie(detectorObj, traces, artifact, threshold, movie)
            nTraces = size(traces,1);
            spikesDetectedMat = zeros(0,3);
            j = 0;
            for i = 1:nTraces
                [spikeDet, halfMaxIdx] = detectorObj.detectSpike(traces(i, :), artifact, threshold);
                if spikeDet
                    j = j + 1;
                    spikesDetectedMat(j,:) = [movie, i, halfMaxIdx];
                end
            end
            
        end
        
    end
end