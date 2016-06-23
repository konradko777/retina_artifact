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
        %% stability island functions
        function stableThresholdsIdx = getMinimalStableThresholds(QTClassObj, measureMatrix,...
                thresholds, similaritydBreachFunc, minimalCluster)
        % Method returns quantization threshold indices that belong 
        % to first stability island encountered. Stability island is defined
        % as all quantization thresholds that lead to (almost) exactly same
        % classification of traces. At minimalClust of thresholds are
        % needed to form stability island.
        % Input:
        %     measureMatrix(Array<float>): square matrix of difference 
        %         measure between artifact estimates performed for
        %         different values of quantization threshold
        %     thresholds(Vector<Float>): quantization thresholds used when
        %         estimating stimulation artifact
        %     similarityBreachFunc(Handle<Function>): a function that
        %         returns boolean when provided with dissimilarity values
        %         vector. It returns 1 if any of the values is bigger than
        %         passed threshold.
        %     minimalCluster(int): minimul number of threshold to form
        %         stability island
        % Output:
        %     stableThresholdsIdx(Vector<Int>): indices of quantization
        %         thresholds belonging to stability island
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
                [bestThresIdx, bestThres] = QTClassObj.findBestThresholds(measureValForThres, thresholds, i, similaritydBreachFunc);
                if length(bestThresIdx) >= minimalCluster
                    stableThresholdsIdx = bestThresIdx;
                    return
                end
            end
            stableThresholdsIdx = [];
        end
        function [bestThresIdx, bestThres] = findBestThresholds(QTClassObj, valuesVector,...
                thresholds, startThresholdIdx, similarityBreachFunc)
        % Returns stability island threshold indices and quantization
        % thresholds themselves.
        % Input:
        %     valuesVector(Vector<Float>): vector of dissimilarity measures
        %     thresholds(Vector<Float>): quantization thresholds used when
        %         estimating stimulation artifact
        %     startThresholdIdx(Int): index of first threshold included in
        %         comparison
        %     similarityBreachFunc(Handle<Function>): a function that
        %         returns boolean when provided with dissimilarity values
        %         vector. It returns 1 if any of the values is bigger than
        %         passed threshold.
        % Output:
        %     bestThresIdx(Vector<Int>): indices of thresholds in stability 
        %         island
        %     bestThres(Vector<Float>): valuse of thresholds in stability
        %         island
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
        % Creates dictionary which keys are numbers of thresholds in
        % stability island and values are expected length of dissimilarity 
        % measure vector.
        % Input:
        %     n(Int): biggest possible stability island.
        % Output:
        %     expectedLengthDict(containers.Map): dictionary with number of
        %         thresholds(integers up to n) in stability islands as keys
        %         and expected lengths of dissimilarity measure vectors.
            keys = 1:n;
            vals = zeros(size(keys));
            for i = 1:n
                vals(i) =  QTClassObj.getExpectedNOfElements(i);
            end
            expectedLengthDict = containers.Map(keys, vals);


        end
        function nElements = getExpectedNOfElements(QTClassObj, n)
        % A function that returns how many values should be in a vector
        % with dissimilarity measures if stability island consists of n
        % thresholds. Dissimilarity measure is computed for each pair of
        % artifact estimates obtained with different quantization
        % threshold.
        % Input:
        %     n(Int): number of thresholds in stability island
        % Output:
        %     nElements(Int): expected number of elements provided in
        %         stability island there are n thresholds.
            if n == 1
                nElements = 0;
            else
                nElements = sum(1:n-1);
            end
        end
        function stableThresIdx = getThresIdxFromIsland(QTClassObj, stabilityIsland)
        % Returns index of lowest quantization threshold in stability
        % island. If stabilityIsland vector is empty, returns 0.
        % Input:
        %     stailityIsland(Vector<Int>): indices of thresholds belonging
        %         to stability island.
        % Output:
        %     stableThresIdx(Int): lowest(first) index of indices in vector
        %         stabilityIsland.
            if isempty(stabilityIsland)
                stableThresIdx = 0;
            else
                stableThresIdx = stabilityIsland(1);
            end            
        end
        function stableThresIdx = getLastIdxFromIsland(QTClassObj, stabilityIsland)
        % Returns index of largest quantization threshold in stability
        % island. If stabilityIsland vector is empty, returns 0.
        % Input:
        %     stailityIsland(Vector<Int>): indices of thresholds belonging
        %         to stability island.
        % Output:
        %     stableThresIdx(Int): highest(last) index of indices in vector
        %         stabilityIsland.
            if isempty(stabilityIsland)
                stableThresIdx = 0;
            else
                stableThresIdx = stabilityIsland(end);
            end            
        end
        %% main methods
        function [artifactIDs, largestQT] = getArtIDsAndLargestQT(QTClassObj, traces)
        % Performs artifact classification for set of traces coming from
        % electrode and movie returning IDs of traces classified as
        % artifacts (# of repetition) and largest quantization threshold in
        % stability island.
        % Input:
        %     traces(Array(Float): a matrix containing registered responses 
        %         for each stimulus in given movie. Each row represents 
        %         electrical response of the system for one stimulus.
        % Output:
        %     artifactIDs(Vector<Int>): IDs(# of repetition) of traces 
        %         classified as artifacts
        %     largestQT(Float): value of largest quantization threshold in
        %         stability island
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
%         function QT = getHighestQT(QTClassObj, traces)
%             nThresholds = length(QTClassObj.THRESHOLDS);
%             thresholdAlgoHandles = cell(nThresholds, 1);
%             algorithmHandle = @(traces, threshold) QTClassObj.nDRWplusPruning(traces,...
%                 threshold, QTClassObj.VOTES_TO_EXCLUDE, ...
%                 QTClassObj.ART_TO_PRUNE, QTClassObj.SAMPLES_LIM);
%             for i = 1:nThresholds
%                 thresholdAlgoHandles{i} = ...
%                     @(traces) algorithmHandle(traces, QTClassObj.THRESHOLDS(i));
%             end
%             [artifactIDsMatrix,  ~, ~]  = QTClassObj.computeIDsMatrices(traces, thresholdAlgoHandles);
%             meanArtifacts = QTClassObj.computeMeanArtifacts(traces, artifactIDsMatrix);
%             measureMatrix = QTClassObj.computeMeasureMat(meanArtifacts(:, QTClassObj.SAMPLES_LIM(1):QTClassObj.SAMPLES_LIM(2)), @QTClassObj.cmpDiffMeasureVec);
%             breachFuncHandle = @(simValuesVec) QTClassObj.thresholdBreachFunc(simValuesVec, QTClassObj.STABILITY_THRESHOLD);
%             stabilityIslandThresholds = QTClassObj.getMinimalStableThresholds(measureMatrix, QTClassObj.THRESHOLDS, breachFuncHandle, QTClassObj.MINIMAL_CLUSTER);
%             highestThresholdIdx = QTClassObj.getLastThresIdxFromIsland(stabilityIslandThresholds);
%             QT = QTClassObj.THRESHOLDS(highestThresholdIdx);
%         end
        function [artifactIDsMatrix, excludedIDsMatrix, spikesIDsMatrix] = ...
                computeIDsMatrices(QTClassObj, traces, algoHandlesVec)
        % Performs classification of traces for each algorithm function
        % handle (with different QT) in algoHandleVec vector. Return three
        % CellArrays, where i-th cell store results for classification with
        % i-th algorithm function handle stored in algoHandlesVec.
        % Input:
        %     traces(Array(Float): a matrix containing registered responses 
        %         for each stimulus in given movie. Each row represents 
        %         electrical response of the system for one stimulus.
        %     algoHandlesVec(Vector<FunctionHandle>): each handle in the
        %         vector points to algorithm function with different
        %         quantization threshold.
        % Output:
        %     artifactIDsMatrix(Cell<Vector<Int>>): in each cell traces'
        %         IDs classified as artifacts are stored.
        %     excludedIDsMatrix(Cell<Vector<Int>>): in each cell traces'
        %         IDs excluded from artifact candidates set are stored.
        %     spikesIDsMatrix(Cell<Vector<Int>>): in each cell traces'
        %         IDs NOT classified as artifacts nor excluded are stored.
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
        %%helper methods
        function similarityBreach = thresholdBreachFunc(QTClassObj, simValuesVec, breachThreshold)
        % Returns boolean whether any value in vector simValuesVec exceeds given
        % threshold breachThreshold.
        % Input:
        %     simValuesVec(Vector<Float>): a vector with dissimilarity
        %        measures values
        %     breachThreshold(Float): threshold value that has to be
        %         excceded to report similarity breach
        % Output:
        %     similarityBreach(Boolean): if one(true) it means that at least 
        %         one value in simValueVec is to high regarding
        %         breachThreshold.
            if any(isnan(simValuesVec))
                similarityBreach = 1;
            else
                similarityBreach = any(simValuesVec > breachThreshold);
            end
        end    
        function meanArtifacts = computeMeanArtifacts(QTClassObj, oneChannelTraces, artifactIDsMatrix)
        % Computes mean artifacts matrix for different classifications of
        % traces as artifacts.
        % Input:
        %     oneChannelTraces(Array<Float>): a matrix containing
        %         registered responses for each stimulus in given movie.
        %         Each row represents electrical response of the system for
        %         one stimulus.
        %     artifactIDsMatrix(Cell<Vector<Int>>): a cell matrix where each cell
        %          contains IDs(# repetition) of traces classified as
        %          artifacts. ID corresponds to the row no. of
        %          oneChannelTraces matrix.
        % Output:
        %     meanArtifacts(Array<Float>): in each row there is a mean of
        %          traces which ID was specified in corresponding cell of
        %          artifactIDsMatrix
            oneChannelTraces = squeeze(oneChannelTraces);
            size(oneChannelTraces);
            traceLength = size(oneChannelTraces, 2);
            meanArtifacts = zeros(length(artifactIDsMatrix), traceLength);
            for  i = 1:size(artifactIDsMatrix, 1)
                artifacts = artifactIDsMatrix{i};
                if length(artifacts) == 1
                    meanArtifacts(i, :) = oneChannelTraces(artifacts, :);
                else
                    meanArtifacts(i, :) = mean(oneChannelTraces(artifacts, :));
                    % if there is no artifacts found, result is a NaN
                end
            end
        end
        function diffMeasure = cmpDiffMeasureVec(QTClassObj, vec1, vec2)
        % A function that computes sum of absolute difference between two
        % vectors, It is treated as difference measure  in our algorithm
        % between two artifact estimates.
        % Input:
        %     vec1, vec2(Vector<Float>): two vectors of floats numbers. 
        % Output: 
        %     diffMeasure(Float): a sum of absolute difference between two
        %         vectors. May be interpreted as area between two curves
        %         represented by vec1 and vec2.
            diffMeasure = sum(abs((vec1 - vec2)));
        end
        function measureMat = computeMeasureMat(QTClassObj, meanArtifacts, measureFuncHandle)
        % Computes difference mueasure between every pair of artifacts in
        % meanArtifacts matrix.
        % Input:
        %     meanArtifacts(Array<Float>): each row of the matrix
        %         represents an artifact estimate.
        %     measureFuncHandle(Handle<Function>): a function handle that
        %         is capable of computing a difference measure when
        %         provided with two vectors. It should return a single
        %         number.
        % Output:
        %     measureMat(Array<Float>): A symmetrical matrix which (i-th,
        %         j-th) value represents difference measure between vectors
        %         being i-th and j-th row of meanArtifacts matrix.
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
        % A method that performs classification of traces for given movie
        % and stimulation current
        % Input:
        %     Waveforms(Array<Float>): a matrix containing registered
        %         responses for each stimulus in given movie. Each row 
        %         represents electrical response of the system for
        %         one stimulus.
        %     QuantTh(Float): a threshold that has to exceeded to state
        %         that artifactCandidate most likely is not a stimulation
        %         artifact, but contains also neural activity.
        %     nDRW(Int): number of disqualifying resultant waveforms -
        %         minimal number of traces lying above tested one that
        %         eliminates it as artifact-only candidate.
        %     artToPrune(Int): number of artifacts excluded from the
        %         artifact candidate set after the classification has been
        %         performed. Candidates most differing from the mean of
        %         the set are excluded.
        %     sampleLim(Vector<Int>): a two element vector that specifies
        %         first and last sample of region that is taken under
        %         consideration (usually we omit the stimulation phase, and
        %         sample coming more than 2ms after stimulus)
        % Output:
        %     resultStruct(Structure): a structure summarising the results 
        %         of trace classification. It consist of three fields:
        %         1. artifactIDs(Vector<Int>): IDs(# of repetition) of
        %             traces classified as artifacts.
        %         2. excluded(Vector<Int>): IDs of excluded most differing 
        %             artifact candidates
        %         3. spikes(Vector<Int>): rest of trace IDs not belonging
        %             to any of abovementioned groups.
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
        
        function [ NumberOfDRW ] = nDRWFunction(Waveforms, artifactCandidate,...
                QuantTh, samplesLim)
        % A method that tells how many traces lays above artifactCandidate.
        % Input:
        %     Waveforms(Array<Float>): a matrix containing registered
        %         responses for each stimulus in given movie. Each row 
        %         represents electrical response of the system for
        %         one stimulus.
        %     artifactCandidate(Vector<Float>): a trace that we want to
        %         test for being a only-stimulation-artifact case. One of
        %         rows of Waveforms matrix.
        %     QuantTh(Float): a threshold that has to exceeded to state
        %         that artifactCandidate most likely is not a stimulation
        %         artifact, but contains also neural activity.
        %     sampleLim(Vector<Int>): a two element vector that specifies
        %         first and last sample of region that is taken under
        %         consideration (usually we omit the stimulation phase, and
        %         sample coming more than 2ms after stimulus)
        % Output:
        %     NumberOfDRW(Int): number of disqualifying resultant
        %         waveforms- states how many traces lays above examined
        %         artifactCandidate. The more the number is, the less
        %         probable that the candidate is indeed
        %         only-stmulation-artifact trace.
        %         
            nDRW = 0; 
            nWaveforms = size(Waveforms,1);
            resultantWaveforms = Waveforms(:,:)-repmat(artifactCandidate,nWaveforms,1);
            resultantWaveforms(:,samplesLim(2):end) = [];
            resultantWaveforms(:,1:samplesLim(1)) = [];
            quantizedWaveforms = zeros(size(resultantWaveforms));
            quantizedWaveforms(resultantWaveforms > QuantTh) = 1;
            quantizedWaveforms(resultantWaveforms < -QuantTh) = -1;
            % If first, nonzero element is plus one, we detect Disqualifying
            % Resultant Waveform.
            for iQWave = 1:size(quantizedWaveforms,1)
                sequence = quantizedWaveforms(iQWave,:);
                sequence(sequence == 0) = [];
                if ~isempty(sequence) && sequence(1) == 1
                    nDRW = nDRW + 1;
                end
            end
            NumberOfDRW = nDRW;
        end


        
    end
end