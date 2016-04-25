MAX_VALUE = 50;
MIN_SPIKES = 10;
addJava
%%
DESIRED_EFF_VEC = .75:.01:.95;
% DESIRED_EFF_VEC(end) = .99;
difference_vec = zeros(size(DESIRED_EFF_VEC));

for p = 1:length(difference_vec)
    DESIRED_EFF = DESIRED_EFF_VEC(p);
    
    setGlobals512
    load stimEleFoundFixed

    neuronFitAmpMat = getNeuronsFittedAmpsMat(nOfSpikesDetDict, MAX_VALUE, MIN_SPIKES, DESIRED_EFF);
    neuronAlgoThresAmpsMat = getNeuronAlgoThresAmps(nOfSpikesDetDict);
    mergedMat1 = mergeMatrices(neuronAlgoThresAmpsMat, neuronFitAmpMat);

    setGlobals512_00
    load 512_00_all_vars

    neuronFitAmpMat = getNeuronsFittedAmpsMat(nOfSpikesDetDict, MAX_VALUE, MIN_SPIKES, DESIRED_EFF);
    neuronAlgoThresAmpsMat = getNeuronAlgoThresAmps(nOfSpikesDetDict);
    mergedMat2 = mergeMatrices(neuronAlgoThresAmpsMat, neuronFitAmpMat);

    setGlobals512_03
    load 512_03_all_vars

    neuronFitAmpMat = getNeuronsFittedAmpsMat(nOfSpikesDetDict, MAX_VALUE, MIN_SPIKES, DESIRED_EFF);
    neuronAlgoThresAmpsMat = getNeuronAlgoThresAmps(nOfSpikesDetDict);
    mergedMat3 = mergeMatrices(neuronAlgoThresAmpsMat, neuronFitAmpMat);


    allMerged = [mergedMat1; mergedMat2; mergedMat3];
    %[neuronID, 50%, 100%, thresFileAmplitude, fittedAmp]
    difference_vec(p) = sum(sqrt((allMerged(:,4) - allMerged(:,5)).^2));
    p
end