classdef (Abstract) abstractSpikeDetector < handle
% An abstract class whose realisations must be able to classify a trace as
% a spike provided with artifact model and a threshold. It has to be able 
% to determine spike timing. All spikeDetector objects must implement
% detectSpike method.
    methods (Abstract)
        function [spikeDetected, spikeRegistrationSample] = ...
            detectSpike(detectorObj, trace, artifactModel, threshold)
        % Classifies given trace and if spike is found return information
        % about spike timing.
        % Input:
        %     trace(Vector<Float>): a voltage registered after delivering
        %         electrical stimulus
        %     artifactModel(Vector<Float>): a model of stimulation artifact
        %     threshold(Float): spike detection threshold
        end
    end
end