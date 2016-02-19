function electrode = findBestEleFromEI(neuron, EI)
% EI format (nElectrodes x nSamples)
    global NEURON_ELE_MAP ELE_MAP_OBJ
    stimEle = NEURON_ELE_MAP(neuron);
    adjacentEles = ELE_MAP_OBJ.getAdjacentsTo(stimEle,1);
    [~, electrodePositionIdx] = min(min(EI(adjacentEles + 1, :),[], 2)); %+1 to match the EI format(0th channel)
    electrode = adjacentEles(electrodePositionIdx);
end