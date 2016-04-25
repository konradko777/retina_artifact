MAX_VALUE = 50;
MIN_SPIKES = 10;
DESIRED_EFF = .92;
addJava
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
%%

hold on
% plotEfficiencyScatter4(allMerged(:,3), allMerged(:,4))
plot(allMerged(:,5), allMerged(:,4), 'b.', 'MarkerSize', 15)
plot(amplitudeValues, amplitudeValues, 'r')
xlabel('Fitted Amplitude [\muA]', 'fontsize', 25)
ylabel('Manually chosen amplitude [ \muA]', 'fontsize', 25)
% lh = legend('1 neuron by algo', '2-5 neurons by algo','5 - 10 neurons by algo','> 10 neurons by algo', '1 neuron by fitting');
% set(lh, 'location', 'southeast')
% correctLegendScatter(lh)
set(gca, 'fontsize', 20)

%%

hold on
plotEfficiencyScatter4(allMerged(:,3), allMerged(:,4))
% plot(allMerged(:,5), allMerged(:,4), 'b.', 'MarkerSize', 10)
plot(amplitudeValues, amplitudeValues, 'r')
xlabel('Amplitude chosen by algorithm [\muA]', 'fontsize', 25)
ylabel('Manually chosen amplitude [ \muA]', 'fontsize', 25)
lh = legend('1 neuron by fitting', '2-5 neurons by algo','5 - 10 neurons by algo','> 10 neurons by algo');
set(lh, 'location', 'southeast')

set(gca, 'fontsize', 20)
correctLegendScatter(lh)


%% getting apmplitude values
global DATA_PATH
ampMovieDict = createAmpMovieMap(DATA_PATH);
movieAmpDict = reverseDict(ampMovieDict);
nOfAmps = length(keys(movieAmpDict));
amplitudeValues = zeros(nOfAmps, 1);
for i = 1: nOfAmps
    amplitudeValues(i) = movieAmpDict(2*i - 1);    
end


%%

plotScatterWithTextLabels(allMerged(:,1), allMerged(:,5), allMerged(:,4), amplitudeValues, 10)

%% hist
ratio = allMerged(:,4) ./ allMerged(:,5); % thres value / fitted value
ratio(isinf(ratio)) = [];
ratio(isnan(ratio)) = [];
length(ratio)
hist(ratio)

%% plotting with text labels 



