MAX_VALUE = 50;
MIN_SPIKES = 10;
DESIRED_EFF = .99;
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

hold on
plot(allMerged(:,5), allMerged(:,4), 'b.')
plot(amplitudeValuesDense, amplitudeValuesDense, 'r')
plotEfficiencyScatter(allMerged(:,3), allMerged(:,4))
xlabel('Fitted Amplitude [\muA]', 'fontsize', 25)
ylabel('Manually chosen amplitude [\muA]', 'fontsize', 25)
set(gca, 'fontsize', 20)

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



