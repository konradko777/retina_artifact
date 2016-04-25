function whichSet = mapNeuronToDataSet(neuronID, allMergedMat)
    thres1 = 70;
    thres2 = 129;
    idx = find(allMergedMat(:,1) == neuronID,1);
    if isempty(idx)
        error('neuronID not present in any dataset')
    end
    if idx <= thres1
        whichSet = 1;
    elseif idx <= thres2
        whichSet = 2;
    else
        whichSet = 3;
    end
    

end