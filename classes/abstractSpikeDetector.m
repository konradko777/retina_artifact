classdef (Abstract) abstractSpikeDetector < handle
% An abstract class whose realisations must be able to classify a trace as
% a spike provided with artifact model and a threshold. All spikeDetector
% objects must implement detectSpike method.
    methods (Abstract)
        function [spikeDetected, spikeRegistrationSample] = ...
            detectSpike(detectorObj, trace, artifactModel, threshold)
        end
    end
end