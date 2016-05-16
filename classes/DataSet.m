classdef DataSet < handle
    properties
        dataPath
        EIFile
        neuronIdx
        artClassifierObj
        spikeDetectorObj
        electrodeLayoutObj
        neuronIdxEIElectrodeMap
        neuronIdxEISpikeAmpMap
        
        
    end
    
    methods
        function dataSetObj = DataSet(dataPath, EIFilePath, neuronIdx)
            dataSetObj.dataPath = dataPath;
            dataSetObj.neuronIdx = neuronIdx;
            dataSetObj.EIFile = ...
                edu.ucsc.neurobiology.vision.io.PhysiologicalImagingFile(EIFilePath);
            dataSetObj.electrodeLayoutObj = edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(500);
            dataSetObj.createEIMappings
        end
        
        function createEIMappings(dataSetObj)
            [EIElectrodes, EISpikeAmps] = findBestEleAndSpikeAmpFromEIForNeurons(dataSetObj.neuronIdx);
            EIElectrodes
            function [electrodes, spikeAmps]= findBestEleAndSpikeAmpFromEIForNeurons(neurons)
                %returns the the spikeAmplitude(the most negative sample in ei) and
                %   electrode associated with it
                electrodes = zeros(size(neurons));
                spikeAmps = zeros(size(neurons));
                i = 1;
                for neuron = neurons
                    ei = getEIForNeuron(dataSetObj, neuron);
                    electrodes(i) = findBestEleFromEI(dataSetObj, neuron, ei);
                    spikeAmps(i) = findSpikeAmpFromEI(electrodes(i), ei); %dopisac
                    i = i + 1;
                end
            end
            
            function electrode = findBestEleFromEI(dataSetObj, neuron, EI)
                % EI format (nElectrodes x nSamples)
                global NEURON_ELE_MAP
                stimEle = NEURON_ELE_MAP(neuron);
                adjacentEles = dataSetObj.electrodeLayoutObj.getAdjacentsTo(stimEle,1);
                [~, electrodePositionIdx] = min(min(EI(adjacentEles + 1, :),[], 2)); %+1 to match the EI format(0th channel)
                electrode = adjacentEles(electrodePositionIdx);
                %2ga wersja
%                 [~, electrodePositionIdx] = min(min(EI,[], 2));
%                 electrode = electrodePositionIdx - 1;
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
        

    end
end