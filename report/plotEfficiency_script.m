addJava
% setGlobals512
% load wszystkie_70
% setGlobals512_00
% load 512_00_all_vars

setGlobals512_03
load 512_03_all_vars
bestMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
%%
global NEURON_IDS
algoFull = getMovieIdxFromDict(NEURON_IDS, bestMoviesDict, 2);
thresFileIdx = getMovieIdxFromDict(NEURON_IDS, bestMoviesDict, 3);

% algoHalf = algoHalf + rand(size(algoHalf)) / 4;


plotEfficiencyScatter(algoFull, thresFileIdx)
% plot(thresFileIdx, a  lgoHalf, 'b.')

%%
for neuron = NEURON_IDS
%     neuroN
    fprintf('%d, %d, %d, %d \n', [neuron, bestMoviesDict(neuron)])
end

