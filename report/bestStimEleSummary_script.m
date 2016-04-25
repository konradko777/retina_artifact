addJava
global NEURON_IDS
setGlobals512
load hex512_allRes

% setGlobals512_00
% load 512_00_hex_allRes.mat

% setGlobals512_03
% load 512_03_hex_allRes.mat

neuronBestEle = zeros(0,3);
i = 0;
for neuron = NEURON_IDS%(1:70)
    i = i + 1;
    bestAlgoEle = getBestStimEle100(neuronResultStructDict(neuron));
    thresEle = getCorrectedThresFileStimEle(neuron);
    neuronBestEle(i,:) = [neuron, bestAlgoEle, thresEle];
end

% neuronBestEle

%%
length(neuronBestEle(neuronBestEle(:,2) == neuronBestEle(:,3),:))
neuronBestEle(neuronBestEle(:,2) == neuronBestEle(:,3),:)
%7278 przyklad do pokazania roznicy
%6110 do pokazania przyk?adu gdzie r?czna analiza nie znalaz?a elektrody