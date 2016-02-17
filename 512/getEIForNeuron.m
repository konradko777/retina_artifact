function ei = getEIForNeuron(neuronID)
    global EI_FILE
    ei = EI_FILE.getImage(neuronID);
    resizeDims = size(ei);
    resizeDims = resizeDims([2,3]);
    ei = reshape(ei(1,:,:), resizeDims);
end