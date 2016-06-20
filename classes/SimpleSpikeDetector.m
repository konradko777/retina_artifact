classdef SimpleSpikeDetector < abstractSpikeDetector
% A simple spike detector that subtracts artifact model from examined trace
% snd checks whether detection threshold was surpassed
%
    properties
        samplesOfInterest
    end
    
    methods
        function detectorObj = SimpleSpikeDetector(samplesOfInterest)
        % Creates SimpleSpikeDetector object
        % Input:
        %   samplesOfInterest(Array<Int>) : one dimensional array of 2 integers,
        %       which specifies the samples in trace, that are taken under
        %       consideration, when looking for spikes. Format: [first
        %       last].
        %   
            detectorObj.samplesOfInterest = samplesOfInterest;
            
        end
        function [spikeDetected, halfMinIdx] = detectSpike(detectorObj, ...
                trace, artifact, threshold)
        % A method that subtracts artifact model from trace, and checks
        % whether given electrode registered neural activity. When
        % threshold is surpassed trace is declared spike. Method returns
        % timing of the spike defined as a sample(interpolated, so it is
        % not necessarily integer valued) when half-amplitude value is
        % reached
        % Input:
        %     trace(Vector<Float>): voltage time series registered on
        %         electrode (during and) after stimulation.
        %     artifact(Vector<Float>): time series of valtage with the same
        %         dimensions as trace.
        %     threshold(Float): when more negative sample than the threshold
        %         is found in a vector resulting from subtraction of
        %         artifact from trace, trace is delcared as spike.
        % Output:
        %     spikeDetected(Boolean): whether trace is declared as spike or
        %         not
        %     halfMinIdx(Bloat): a interpolated sample value, when voltage
        %         reaches value eqaul to half-amplitude of spike. Amplitude
        %         of spike is defined as the most negative sample in the
        %         region 
            halfMinIdx = 0;
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
            greaterThanHalfMinIdx = i + detectorObj.samplesOfInterest(1) - 1;
            smallerThanHalfMinIdx = greaterThanHalfMinIdx + 1;
            indices = [greaterThanHalfMinIdx smallerThanHalfMinIdx];
            halfMinIdx = interp1(subtracted(indices), indices, minValue / 2);    
            end
        end
    end
end