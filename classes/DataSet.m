classdef DataSet < handle
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
        
        
    end
    
    methods
        function dataSetObj = DataSet(dataPath, EIFilePath, neuronIdx)
            dataSetObj.dataPath = dataPath;
            dataSetObj.neuronIdx = neuronIdx;
            dataSetObj.EIFile = ...
                edu.ucsc.neurobiology.vision.io.PhysiologicalImagingFile(EIFilePath);
            dataSetObj.createEIMappings
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

    end
end