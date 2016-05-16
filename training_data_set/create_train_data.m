% tworzy model artefaktu, a nie dokonuje pelnej klasyfikacji
% odrzuca 2 ze zbioru artefaktow 
% [8 37] zakres branych probek

addJava
setGlobals512_00
load 512_00_all_vars
%%
%typical
neurons = [32 32 32 68 68 68 68 68 217 217 217 217 217 217 217 217 ones(1, 9)*230];
movies = [19 20 21 7 12 13 14 15 6 7 8 9 10 11 12 13 14 11:19];

%3 klastry
% neurons = [68 68];
% movies = [12 13];

allTraces = zeros(length(neurons), 50, 140);
classification = zeros(length(neurons), 50);
for i = 1:length(neurons)
    allTraces(i, :, :) = getTracesForNeuronMovie(neurons(i), movies(i) *2 - 1);
    stableThres = thresDict(neurons(i));
    stableThres = stableThres(movies(i));
    artIDs = artDict(neurons(i));
    artIDs = artIDs{movies(i)};
    classification(i, artIDs{stableThres}) = 1;
    
end

%%
hold on
occurance = 25;
plot(squeeze(allTraces(occurance, :, :))', 'k')
plot(squeeze(allTraces(occurance, logical(classification(occurance, :)), :))', 'r')