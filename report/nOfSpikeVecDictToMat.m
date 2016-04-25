function mat = nOfSpikeVecDictToMat(vecDict, addToNeuronID)
    mat = zeros(0,0);
    i = 0;
    for neuronCell = keys(vecDict)
        i = i + 1;
        neuronID = neuronCell{1};
        mat(i, :) = [neuronID + addToNeuronID vecDict(neuronID)];        
    end
end