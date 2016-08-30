%% setting globals and loading data

addJava
global NEURON_IDS
% setGlobals512
% load hex512_allRes

% setGlobals512_00
% load 512_00_hex_allRes.mat

setGlobals512_03
load 512_03_hex_allRes.mat

%% comparing electrodes saved in threshold files against those found by algo
neuronBestEle = zeros(0,3);
i = 0;
for neuron = NEURON_IDS%(1:70)
    i = i + 1;
    bestAlgoEle = getBestStimEle100(neuronResultStructDict(neuron));
    thresEle = getCorrectedThresFileStimEle(neuron);
    neuronBestEle(i,:) = [neuron, bestAlgoEle, thresEle];
end

%% getting neurons with same electrodes manually and algorthmically
sameElectrodes = neuronBestEle(:,2) == neuronBestEle(:,3);
nonZeros = neuronBestEle(:,2) ~= 0;
consistentNeurons = neuronBestEle(sameElectrodes & nonZeros,:);
% consistentNeurons = consistentNeurons(:, 1);

%%
% load('C:\studia\dane_skrypty_wojtek\ks_functions\hex512\hex512_allRes_old')
% load('C:\studia\dane_skrypty_wojtek\ks_functions\512_00\512_00_hex_allRes_old')
load('C:\studia\dane_skrypty_wojtek\ks_functions\512_03\512_03_hex_allRes_old')

smallestQTs = zeros(size(consistentNeurons, 1), 1);

for i = 1:size(consistentNeurons, 1)
    neuronEleIds = consistentNeurons(i, :);
    allResForNeuron = neuronResultStructDict(neuronEleIds(1));
    for j = 1:length(allResForNeuron)
        oneEleResStruct = allResForNeuron{j};
        if oneEleResStruct.StimEle == neuronEleIds(2)
            smallestQTs(i) = THRESHOLDS(oneEleResStruct.stableThresIdx);
        end
    end
end

%% after merge

allSmallestQTs = [smallestQTs1; smallestQTs2; smallestQTs3];
counts = histc(allSmallestQTs, THRESHOLDS);
hold on
bar(THRESHOLDS, counts, 'histc')
set(gca, 'fontsize', 20)
for i1=1:numel(counts)
    text(THRESHOLDS(i1) + 2.5,counts(i1),num2str(counts(i1),'%d'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom', 'fontsize', 20)
end