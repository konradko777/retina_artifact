
global NEURON_IDS
addJava

% setGlobals512
% load stimEleFoundFixed
% neuronSpikeDetVecMat = nOfSpikeVecDictToMat(nOfSpikesDetDict, 0);


setGlobals512_00
load 512_00_all_vars
neuronSpikeDetVecMat = nOfSpikeVecDictToMat(nOfSpikesDetDict, 0);

% setGlobals512_03
% load 512_03_all_vars
% neuronSpikeDetVecMat = nOfSpikeVecDictToMat(nOfSpikesDetDict, 0);


MAX_VALUE = 50;
MIN_SPIKES = 10;
onlySpikeMat = neuronSpikeDetVecMat(:, 2:end);
transformedOnlySpikeMat = zeros(size(onlySpikeMat));
for i = 1:size(transformedOnlySpikeMat, 1)
    transformedOnlySpikeMat(i, :) = transformSpikeDetVec(onlySpikeMat(i,:), MAX_VALUE, MIN_SPIKES);
end

%% getting apmplitude values
global DATA_PATH
ampMovieDict = createAmpMovieMap(DATA_PATH);
movieAmpDict = reverseDict(ampMovieDict);
nOfAmps = length(keys(movieAmpDict));
amplitudeValues = zeros(nOfAmps, 1);
for i = 1: nOfAmps
    amplitudeValues(i) = movieAmpDict(2*i - 1);    
end

%% plotting

for i = 1:70
    subplot(7, 10, i)
    hold on
    plot(amplitudeValues, transformedOnlySpikeMat(i, :) * 50, 'g.-')
    plot(amplitudeValues, onlySpikeMat(i,:), 'b.-')
    title(num2str(neuronSpikeDetVecMat(i, 1)))
    ylim([0 50])
%     ylim([0 1])
    
end

%%
i = 22;
amplitudeValuesDense = amplitudeValues(1):0.01:amplitudeValues(end);
coeffs = lsqcurvefit(@sigmoidalFunc, [1, 0], amplitudeValues, transformedOnlySpikeMat(i,:)');
hold on
plot(amplitudeValues, transformedOnlySpikeMat(i,:), 'g.-')
plot(amplitudeValuesDense, sigmoidalFunc(coeffs, amplitudeValuesDense))
ylim([0, 1.01])


%% getting coeff from the fit
amplitudeValuesDense = amplitudeValues(1):0.01:amplitudeValues(end);

allCoeffs = zeros(0,2);
for i = 1:70
    nOfSpikesTransed = transformedOnlySpikeMat(i,:)';
    
    if max(nOfSpikesTransed) == 1
        allCoeffs(i, :) = lsqcurvefit(@sigmoidalFunc, [1, 0], amplitudeValues, transformedOnlySpikeMat(i,:)');
    else
        allCoeffs(i, :) = [0, 0];
    end
    
end

%% getting amplitude value from the fit
desiredEff = .90;
amps = zeros(1, 70);
for i = 1:70
    coeffs = allCoeffs(i, :);
    if all(coeffs)
        amps(i) = sigmoidalInv(coeffs, desiredEff);
    end
end

%% plotting fitted amps and threshold amps

neuronAlgoThresAmpsMat = getNeuronAlgoThresAmps(nOfSpikesDetDict); % gettin amplitudes from algorithm (find 50%, 100%) threshold files(100%) 
neuronFittedAmp = [neuronSpikeDetVecMat(:,1), amps'];
neuronFittedThresAmp = mergeMatrices(neuronFittedAmp, neuronAlgoThresAmpsMat(:,[1 4]));

for i = 1:70
    subplot(7, 10, i)
    hold on
    plot(amplitudeValues, transformedOnlySpikeMat(i, :), 'g.-')
    fittedAmp = neuronFittedThresAmp(i, 2);
    thresAmp = neuronFittedThresAmp(i, 3);
    line([fittedAmp, fittedAmp], ylim, 'color', 'r')
    line([thresAmp, thresAmp], ylim, 'color', 'm')
    title(num2str(neuronSpikeDetVecMat(i, 1)))
    ylim([0 1])
    
end

%%
% global DATA_PATH
ampMovieDict = createAmpMovieMap(DATA_PATH);
movieAmpDict = reverseDict(ampMovieDict);

allResults = zeros(0,4);
% global NEURON_IDS
% addJava
% setGlobals512
% load stimEleFoundFixed
bestMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
z = 0;
for neuron = NEURON_IDS
    z = z + 1;
    allResults(z, :) = [neuron, bestMoviesDict(neuron)];
end

allResults(allResults <= 0) = .5;
allResults(:, 2:end) = allResults(:, 2:end) * 2 - 1;
allResults = int16(allResults);
allResults(:, 2:end) = arrayfun(@(x) mapAmpIdxToAmp(x, movieAmpDict), allResults(:, 2:end));
neuronFittedAmpMat = [neuronSpikeDetVecMat(:, 1) amps'];

[idxa, idxb] = ismember(allResults(:, 1), neuronFittedAmpMat(:, 1));
allResAndFitAmp = [allResults(idxa, :), neuronFittedAmpMat(idxb, 2)];
plot(allResAndFitAmp(:, 5), allResAndFitAmp(:, 4), 'b.')

