addJava
setGlobals512
load hex512_allRes

setGlobals512_00
load 512_00_hex_allRes
global NEURON_ELE_MAP NEURON_REC_ELE_MAP NEURON_SPIKE_AMP_MAP NEURON_IDS ELE_MAP_OBJ
%%
neuronResultStructDict = rewrite100EffInAllResultsDict(neuronResultStructDict);
neuronBestEle = zeros(0,3);
i = 0;
for neuron = NEURON_IDS%(1:70)
    i = i + 1;
    bestAlgoEle = getBestStimEle100(neuronResultStructDict(neuron));
    thresEle = getCorrectedThresFileStimEle(neuron);
    neuronBestEle(i,:) = [neuron, bestAlgoEle, thresEle];
end
algoEleDict = containers.Map(neuronBestEle(:,1), neuronBestEle(:,2));
thresEleDict = containers.Map(neuronBestEle(:,1), neuronBestEle(:,3));
SPIKE_DETECTION_THRES_DICT = createDetectionThresFromSpikeAmp(NEURON_SPIKE_AMP_MAP);

%%

NEURON_ID = 3708%NEURON_IDS(3);

recEle = NEURON_REC_ELE_MAP(NEURON_ID);
stimEle = NEURON_ELE_MAP(NEURON_ID);
eiSpike = getEISpikeForNeuronEle(NEURON_ID, NEURON_REC_ELE_MAP(NEURON_ID));
eiSpikeAmp = NEURON_SPIKE_AMP_MAP(NEURON_ID);
detectionThres = SPIKE_DETECTION_THRES_DICT(NEURON_ID);
adjacentElectrodes = getAdjacentElectrodes(recEle, ELE_MAP_OBJ);
eleRelativePositionDict = createPositionDictForAdjEles(recEle, ELE_MAP_OBJ);
% resultStructs = {};
resultStructs = neuronResultStructDict(NEURON_ID);
%%
set(gcf, 'InvertHardCopy', 'off');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 17.0667  9.6000])
plotHexagonally3(adjacentElectrodes, resultStructs, eiSpike, eiSpikeAmp, detectionThres, thresEleDict(NEURON_ID), algoEleDict(NEURON_ID))
axes('position',[0,0,1,1],'visible','off');
text(.5, 0.98, sprintf('Neuron: %d', NEURON_ID), ...
    'horizontalAlignment', 'center', 'fontsize', 20, 'fontweight', 'bold')
neuronStr = num2str(NEURON_ID);