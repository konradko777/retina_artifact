classdef (Abstract) SpikeDetThresholdServer < handle
    methods (Abstract)
        giveThresholdForElectrodesMovie(stimEle, recEle)
    end
end