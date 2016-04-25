allResults = zeros(0,4);
global NEURON_IDS
addJava
setGlobals512
load stimEleFoundFixed
bestMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
z = 0;
for neuron = NEURON_IDS
    z = z + 1;
    allResults(z, :) = [neuron, bestMoviesDict(neuron)];
end

setGlobals512_00
load 512_00_all_vars
bestMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
for neuron = NEURON_IDS
    z = z + 1;
    allResults(z, :) = [neuron, bestMoviesDict(neuron)];
end

setGlobals512_03
load 512_03_all_vars
bestMoviesDict = createHalfFullThresAmpIdxDict(nOfSpikesDetDict);
for neuron = NEURON_IDS
    z = z + 1;
    allResults(z, :) = [neuron, bestMoviesDict(neuron)];
end

% plotEfficiencyScatter2(allResults(:, 2), allResults(:, 4), [9,32], 'Half efficiency algorithm vs full efficiency manual')
plotEfficiencyScatter2(allResults(:, 3), allResults(:, 4), [12,32], 'Full efficiency algorithm vs full efficiency manual')