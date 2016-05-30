classdef (Abstract) SpikeDetThresholdServer < handle
    methods (Abstract)
        giveThresholdForElectrodes(stimEle, recEle)
    end
end