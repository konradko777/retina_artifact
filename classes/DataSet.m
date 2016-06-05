classdef DataSet < handle
    %zoptymalizowac do 1krotnego czytania danych
    properties
        tracesNumberLimit = 50;
        eventNumber = 0;
        electrodeLayoutObj = edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(500);
        
        dataPath
        EIFile
        neuronIdx
        artClassifierObj
        spikeDetectorObj
        neuronIdxEIElectrodeMap
        neuronIdxEISpikeAmpMap
        artClassifierObject
        spikeDetectionMethod
        thresholdServerObj
    end
    
    methods
        function dataSetObj = DataSet(dataPath, spikeDetectionMethod)
            dataSetObj.dataPath = dataPath;
            dataSetObj.spikeDetectionMethod = spikeDetectionMethod;
%             dataSetObj.EIFile = ...
%                 edu.ucsc.neurobiology.vision.io.PhysiologicalImagingFile(EIFilePath);
%             dataSetObj.createEIMappings
        end %tutaj spikeThresholdMethod i ew. stimEl recEl dictionary
        function attachThresServerObj(dataSetObj, thresServObj)
            dataSetObj.thresholdServerObj = thresServObj;            
        end
        function attachArtClassifierObj(dataSetObj, artClassObj)
            dataSetObj.artClassifierObject = artClassObj;            
        end
        function attachSpikeDetectorObj(dataSetObj, SpikeDetectorObj)
            dataSetObj.SpikeDetectorObj = SpikeDetectorObj;            
        end
        function createEIMappings(dataSetObj)
            [EIElectrodes, EISpikeAmps] = findBestEleAndSpikeAmpFromEIForNeurons(dataSetObj.neuronIdx);
            dataSetObj.neuronIdxEIElectrodeMap = containers.Map(dataSetObj.neuronIdx, EIElectrodes);
            dataSetObj.neuronIdxEISpikeAmpMap = containers.Map(dataSetObj.neuronIdx, EISpikeAmps);
            
            function [electrodes, spikeAmps]= findBestEleAndSpikeAmpFromEIForNeurons(neurons)
                %returns the the spikeAmplitude(the most negative sample in ei) and
                %   electrode associated with it
                electrodes = zeros(size(neurons));
                spikeAmps = zeros(size(neurons));
                i = 1;
                for neuron = neurons
                    ei = getEIForNeuron(dataSetObj, neuron);
                    electrodes(i) = findBestEleFromEI(ei);
                    spikeAmps(i) = findSpikeAmpFromEI(electrodes(i), ei); %dopisac
                    i = i + 1;
                end
            end
            
            function electrode = findBestEleFromEI(EI)
                % EI format (nElectrodes x nSamples)
                [~, electrodePositionIdx] = min(min(EI,[], 2));
                electrode = electrodePositionIdx - 1; %EI has additional 0th channel, thus we need to subtract 1 to match proper electrode
            end
            
            function amp = findSpikeAmpFromEI(electrode, ei)
                %need to add 1 to electrode number to match 513 format of EI
                amp = min(ei(electrode + 1, :));
            end
            
            function ei = getEIForNeuron(dataSetObj, neuronID)
                ei = dataSetObj.EIFile.getImage(neuronID);
                resizeDims = size(ei);
                resizeDims = resizeDims([2,3]);
                ei = reshape(ei(1,:,:), resizeDims);
            end
            
        end
        function traces = getTracesForPatternMovieEle(dataSetObj, pattern, movie, ele)
            [allEleTraces,~,~] = NS_ReadPreprocessedData( ...
                dataSetObj.dataPath, dataSetObj.dataPath,0, pattern, movie, ...
                dataSetObj.tracesNumberLimit, dataSetObj.eventNumber);
            traces = squeeze(allEleTraces(:, ele, :));
        end
%         function allTracesCell = getAllTracesForPatternEle(dataSetObj, pattern, ele, movies
        function artIDs = getArtIDsAndLargestQT(dataSetObj, pattern, movie, ele)
            traces = getTracesForPatternMovieEle(dataSetObj, pattern, movie, ele);
            [artIDs, largestQT] = dataSetObj.artClassifierObject.getArtIDsAndLargestQT(traces);
            if dataSetObj.spikeDetectionMethod == 'largestQT'
                dataSetObj.thresholdServerObj.saveThresForElectrodesMovie(pattern, ele, movie, largestQT);
            end
        end% ta funkcja niepotrzebna?
        function meanArt = getMeanArtForMovie(dataSetObj, pattern, movie, ele)
            traces = getTracesForPatternMovieEle(dataSetObj, pattern, movie, ele);
            [artIDs, largestQT] = dataSetObj.artClassifierObject.getArtIDsAndLargestQT(traces);
            meanArt = mean(traces(artIDs, :));
            if dataSetObj.spikeDetectionMethod == 'largestQT'
                dataSetObj.thresholdServerObj.saveThresForElectrodesMovie(pattern, ele, movie, largestQT);
            end
        end
        function meanArtsMat = getMeanArtsForMovies(dataSetObj, pattern, movies, ele)
            nMovies = length(movies);
            meanArtsMat = cell(nMovies, 1);
            for i = 1:nMovies
                movie = movies(i);
                meanArtsMat{i} = getMeanArtForMovie(dataSetObj, pattern, movie, ele);
            end
            meanArtsMat = cell2mat(meanArtsMat);
        end
        function [spikesDetectedMat] = detectSpikesForMovie(dataSetObj, traces, artifact, threshold, movie)
            nTraces = size(traces,1);
            spikesDetectedMat = zeros(0,3);
            j = 0;
            for i = 1:nTraces
                [spikeDet, halfMaxIdx] = dataSetObj.spikeDetectorObj.detectSpike(traces(i, :), artifact, threshold);
                if spikeDet
                    j = j + 1;
                    spikesDetectedMat(j,:) = [movie, i, halfMaxIdx];
                end
            end
        end
        function detectSpikesForAllMovies(dataSetObj, pattern, recEle, movies)
            
        end
    end
end