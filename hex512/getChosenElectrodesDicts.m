function [algoEleDict, discrepancyNeurons] = getChosenElectrodesDicts(datasetNo)
    addJava
    global NEURON_IDS
    if datasetNo == 1
        setGlobals512
        load hex512_allRes
    elseif datasetNo == 2
        setGlobals512_00
        load 512_00_hex_allRes
    elseif datasetNo == 3
        setGlobals512_03
        load 512_03_hex_allRes
    end
    neuronBestEle = zeros(0,3);
    i = 0;
    for neuron = NEURON_IDS%(1:70)
        i = i + 1;
        bestAlgoEle = getBestStimEle100(neuronResultStructDict(neuron));
        thresEle = getCorrectedThresFileStimEle(neuron);
        neuronBestEle(i,:) = [neuron, bestAlgoEle, thresEle];
    end
    algoEleDict = containers.Map(neuronBestEle(:,1), neuronBestEle(:,2));
    discrepancyIdx = neuronBestEle(:,2) ~= neuronBestEle(:,3);
    discrepancyNeurons = neuronBestEle(discrepancyIdx, 1);

end