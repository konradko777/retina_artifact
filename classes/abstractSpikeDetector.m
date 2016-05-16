classdef (Abstract) abstractSpikeDetector
    methods (Abstract)
        detectSpikes(traces, artifactModel)
    end
end