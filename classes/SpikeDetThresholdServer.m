classdef (Abstract) SpikeDetThresholdServer < handle
% A class that is responsible to serve spike detection threshold for spike
% detecting step in the computation flow. Each realisation of that
% interface has to implement giveThresholdForElectrodesMovie method.
    methods (Abstract)
        threshold = giveThresholdForElectrodesMovie(serverObj, stimEle, ...
            recEle, movie)
        % Main method returning threshold used in spike detection step.
        % Input:
        %     stimeEle(Int): ID of stimulation electrode.
        %     recEle(Int): ID of recording electrode.
        %     movie(Int): integer representation of stimulation amplitude.
    end
end