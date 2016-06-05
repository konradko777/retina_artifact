classdef (Abstract) abstractArtClassifier < handle
    methods (Abstract)
        classifyArtifacts(obj, traces)
    end
end