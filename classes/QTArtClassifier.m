classdef QTArtClassifier < abstractArtClassifier
    properties
        ART_TO_PRUNE = 2;
        SAMPLES_LIM = 8:37;
        VOTES_TO_EXCLUDE = 5;
        THRESHOLDS = 10:5:100;
    end
    
    methods
        
        function artifactIDsMatrix = classifyArtifacts(QTClassObj, traces)
            nThresholds = length(QTClassObj.THRESHOLDS);
            thresholdAlgoHandles = cell(nThresholds, 1);
            algorithmHandle = @(traces, threshold) nDRWplusPruning(traces,...
                threshold, QTClassObj.VOTES_TO_EXCLUDE, ...
                QTClassObj.ART_TO_PRUNE, QTClassObj.SAMPLES_LIM);
            for i = 1:nThresholds
                thresholdAlgoHandles{i} = ...
                    @(traces) algorithmHandle(traces, QTClassObj.THRESHOLDS(i));
            end
            [artifactIDsMatrix,  ~, ~]  = QTClassObj.computeIDsMatrices(traces, thresholdAlgoHandles);
            
        end
        
        
        function [artifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix] = computeIDsMatrices(QTClassObj, traces, algoHandlesVec)
            artifactIDsMatrix = cell(length(algoHandlesVec), 1);
            excludedIDsMatrix = cell(length(algoHandlesVec), 1);
            spikesIDsMatrix = cell(length(algoHandlesVec), 1);
            for i = 1:length(algoHandlesVec)
                algoHandle = algoHandlesVec{i};
                resultStruct = algoHandle(traces);
                artifactIDsMatrix{i} = resultStruct.artifactIDs;
                excludedIDsMatrix{i} = resultStruct.excluded;
                spikesIDsMatrix{i} = resultStruct.spikes;
            end
        end
        
        function diffMeasure = cmpDiffMeasureVec(vec1, vec2)
            diffMeasure = sum(abs((vec1 - vec2)));
        end
        
        function [ resultStruct] = nDRWplusPruning(Waveforms, QuantTh, nDRW, artToPrune, samplesLim)
            %resultStruct fields: artifactIDs, excluded, spikes
            %samplesLim - format [min max] first and last sample taken under
            %   cosideration, the samples outside boundaries are ignored
            resultStruct = struct();
            nWaveforms = size(Waveforms,1);
            numberOfDRW = ones(nWaveforms,1);
            tracesIDs = 1:nWaveforms;
            for iWave = tracesIDs
                tmpArtifact = Waveforms(iWave,:);
                numberOfDRW(iWave) = nDRWFunction(Waveforms, tmpArtifact, QuantTh, samplesLim);
            end
            artifacts = tracesIDs(numberOfDRW < nDRW);
            spikes = setdiff(1:nWaveforms, artifacts);
            if length(artifacts) > artToPrune
                excluded = pruneExtremeArtifacts(Waveforms, artifacts, artToPrune, samplesLim);
                artifacts = setdiff(artifacts, excluded);
            elseif isempty(artifacts)
                excluded = [];
                disp('No artifacts were found');
            else
                excluded = [];
                disp('Not enough artifacts to prune');
            end
            resultStruct.artifactIDs = artifacts;
            resultStruct.excluded = excluded;
            resultStruct.spikes = spikes;
        end
        
    end
end