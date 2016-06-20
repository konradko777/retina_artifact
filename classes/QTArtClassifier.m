classdef QTArtClassifier < handle
    properties
        ART_TO_PRUNE = 2;
        SAMPLES_LIM = [8 37];
        VOTES_TO_EXCLUDE = 5;
        THRESHOLDS = 10:5:150;
        MINIMAL_CLUSTER = 3;
        STABILITY_THRESHOLD = 30;
    end
    
    methods
        function similarityBreach = thresholdBreachFunc(QTClassObj, simValuesVec, breachThreshold)
            if any(isnan(simValuesVec))
                similarityBreach = 1;
            else
                similarityBreach = any(simValuesVec > breachThreshold);
            end
        end    
        %% stability island functions
        function stableThresholds = getMinimalStableThresholds(QTClassObj, measureMatrix,...
                thresholds, similaritydBreachFunc, minimalCluster) %, maxNeighbourDiff, nToFormCluster)
        %measureMatrix(array<float>) - square matrix of difference measure between avgArtifacts
        %thresholds(vector<float>) - quantization thresholds used when computing avgArtifacts
        %maxNeighbourDiff(float) - maximum difference between neighbouring fields
        %   in measureMatrix for thresholds to be declared in one cluster
        %minimalCluster(int) - minimum n to declare stable cluster
            for i = 1:length(thresholds)
                measureValForThres = [];
                for j = i+1:length(thresholds)
                    cellVal = measureMatrix(j, i);
                    measureValForThres = [measureValForThres cellVal];
                    for k = i:j-1
                        if k == i
                            continue
                        end
                        cellVal = measureMatrix(j, k);
                        measureValForThres = [measureValForThres cellVal];
                    end
                end
                [bestThresIdx, bestThres] = QTClassObj.findBestThreshold(measureValForThres, thresholds, i, similaritydBreachFunc);
                if length(bestThresIdx) >= minimalCluster
                    stableThresholds = bestThresIdx;
                    return
                end
            end
            stableThresholds = [];
        end
        function [bestThresIdx, bestThres] = findBestThreshold(QTClassObj, valuesVector,...
                thresholds, startThresholdIdx, similarityBreachFunc)
            nVals = length(valuesVector);
            nThres = length(thresholds);
            lengthDict = QTClassObj.createExpectedValLengthDict(nThres);
            for i=fliplr(1:nThres)
                if nVals >= lengthDict(i)
                    trimmedVals = valuesVector(1:lengthDict(i));
                    if ~similarityBreachFunc(trimmedVals)
                        bestThresIdx = startThresholdIdx:startThresholdIdx + i - 1;
                        bestThres = thresholds(bestThresIdx);
                        return
                    end
                end
            end
        end
        function expectedLengthDict = createExpectedValLengthDict(QTClassObj, n)
            keys = 1:n;
            vals = zeros(size(keys));
            for i = 1:n
                vals(i) =  QTClassObj.getExpectedNOfElements(i);
            end
            expectedLengthDict = containers.Map(keys, vals);


        end
        function nElements = getExpectedNOfElements(QTClassObj, n)
            if n == 1
                nElements = 0;
            else
                nElements = sum(1:n-1);
            end
        end
        function stableThresIdx = getThresIdxFromIsland(QTClassObj, stabilityIsland)
            if isempty(stabilityIsland)
                stableThresIdx = 0;
            else
                stableThresIdx = stabilityIsland(1);
            end            
        end
        function stableThresIdx = getLastIdxFromIsland(QTClassObj, stabilityIsland)
            if isempty(stabilityIsland)
                stableThresIdx = 0;
            else
                stableThresIdx = stabilityIsland(end);
            end            
        end
        %% main methods
        function [artifactIDs, largestQT] = getArtIDsAndLargestQT(QTClassObj, traces)
            nThresholds = length(QTClassObj.THRESHOLDS);
            thresholdAlgoHandles = cell(nThresholds, 1);
            algorithmHandle = @(traces, threshold) QTClassObj.nDRWplusPruning(traces,...
                threshold, QTClassObj.VOTES_TO_EXCLUDE, ...
                QTClassObj.ART_TO_PRUNE, QTClassObj.SAMPLES_LIM);
            for i = 1:nThresholds
                thresholdAlgoHandles{i} = ...
                    @(traces) algorithmHandle(traces, QTClassObj.THRESHOLDS(i));
            end
            [artifactIDsMatrix,  ~, ~]  = QTClassObj.computeIDsMatrices(traces, thresholdAlgoHandles);
            meanArtifacts = QTClassObj.computeMeanArtifacts(traces, artifactIDsMatrix);
            measureMatrix = QTClassObj.computeMeasureMat(meanArtifacts(:, QTClassObj.SAMPLES_LIM(1):QTClassObj.SAMPLES_LIM(2)), @QTClassObj.cmpDiffMeasureVec);
            breachFuncHandle = @(simValuesVec) QTClassObj.thresholdBreachFunc(simValuesVec, QTClassObj.STABILITY_THRESHOLD);
            stabilityIslandThresholds = QTClassObj.getMinimalStableThresholds(measureMatrix, QTClassObj.THRESHOLDS, breachFuncHandle, QTClassObj.MINIMAL_CLUSTER);
            chosenThresholdIdx = QTClassObj.getThresIdxFromIsland(stabilityIslandThresholds);
            highestThresholdIdx = QTClassObj.getLastIdxFromIsland(stabilityIslandThresholds);
            largestQT = QTClassObj.THRESHOLDS(highestThresholdIdx);
            artifactIDs = artifactIDsMatrix{chosenThresholdIdx};
        end
        function QT = getHighestQT(QTClassObj, traces)
            nThresholds = length(QTClassObj.THRESHOLDS);
            thresholdAlgoHandles = cell(nThresholds, 1);
            algorithmHandle = @(traces, threshold) QTClassObj.nDRWplusPruning(traces,...
                threshold, QTClassObj.VOTES_TO_EXCLUDE, ...
                QTClassObj.ART_TO_PRUNE, QTClassObj.SAMPLES_LIM);
            for i = 1:nThresholds
                thresholdAlgoHandles{i} = ...
                    @(traces) algorithmHandle(traces, QTClassObj.THRESHOLDS(i));
            end
            [artifactIDsMatrix,  ~, ~]  = QTClassObj.computeIDsMatrices(traces, thresholdAlgoHandles);
            meanArtifacts = QTClassObj.computeMeanArtifacts(traces, artifactIDsMatrix);
            measureMatrix = QTClassObj.computeMeasureMat(meanArtifacts(:, QTClassObj.SAMPLES_LIM(1):QTClassObj.SAMPLES_LIM(2)), @QTClassObj.cmpDiffMeasureVec);
            breachFuncHandle = @(simValuesVec) QTClassObj.thresholdBreachFunc(simValuesVec, QTClassObj.STABILITY_THRESHOLD);
            stabilityIslandThresholds = QTClassObj.getMinimalStableThresholds(measureMatrix, QTClassObj.THRESHOLDS, breachFuncHandle, QTClassObj.MINIMAL_CLUSTER);
            highestThresholdIdx = QTClassObj.getLastThresIdxFromIsland(stabilityIslandThresholds);
            QT = QTClassObj.THRESHOLDS(highestThresholdIdx);
            
        end
        
        %%helper methods
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
        function meanArtifacts = computeMeanArtifacts(QTClassObj, oneChannelTraces, artifactIDsMatrix)
            oneChannelTraces = squeeze(oneChannelTraces);
            size(oneChannelTraces);
            traceLength = size(oneChannelTraces, 2);
            meanArtifacts = zeros(length(artifactIDsMatrix), traceLength);
            for  i = 1:length(artifactIDsMatrix)
                artifacts = artifactIDsMatrix{i};
                if length(artifacts) == 1
                    meanArtifacts(i, :) = oneChannelTraces(artifacts, :);
                else
                    meanArtifacts(i, :) = mean(oneChannelTraces(artifacts, :)); % w przypadku gdy nie znajduje artefaktow, wynik jest NaN-em
                end
            end
        end
        function diffMeasure = cmpDiffMeasureVec(QTClassObj, vec1, vec2)
            diffMeasure = sum(abs((vec1 - vec2)));
        end
        function measureMat = computeMeasureMat(QTClassObj, meanArtifacts, measureFuncHandle)
            N = size(meanArtifacts, 1);
            measureMat = zeros(N);
            for i = 1:N
                for j = 1:N
                    measureMat(i, j) = measureFuncHandle(meanArtifacts(i, :), meanArtifacts(j, :));
                end
            end
        end
        %% core algorithm
        function [ resultStruct] = nDRWplusPruning(QTClassObj, Waveforms, QuantTh, nDRW, artToPrune, samplesLim)
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