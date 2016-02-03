function plotMeasureForNeuronChoice(neuronID, movies, thresholds, ...
        fullmeasureMat, fullArtifactIDsMatrix, fullClustArtNumVec, ...
        stableThresholdsVec, detectedSpikesVec, chosenMovie, path, colorAxisLim)
    global NEURON_REC_ELE_MAP NEURON_ELE_MAP NEURON_CLUST_FILE_MAP
    recEle = NEURON_REC_ELE_MAP(neuronID);
    patternNumber = NEURON_ELE_MAP(neuronID);
    clusterFileName = NEURON_CLUST_FILE_MAP(neuronID);
    f = figure();
    set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 40 25])
    set(gcf, 'InvertHardCopy', 'off');
    
    for i = 1:length(movies)
        subplot(4,6,i)
        if chosenMovie == i
            plotMeasureForNeuronMovieThresChoice(squeeze(fullmeasureMat(i, :, :)), thresholds, fullArtifactIDsMatrix{i}, fullClustArtNumVec(i),...
                colorAxisLim, true, stableThresholdsVec(i), 1, detectedSpikesVec(i))
        else
            plotMeasureForNeuronMovieThresChoice(squeeze(fullmeasureMat(i, :, :)), thresholds, fullArtifactIDsMatrix{i}, fullClustArtNumVec(i),...
                colorAxisLim, false, stableThresholdsVec(i), 1, detectedSpikesVec(i))
        end
%         title(movieNumber); %dodac odczyt amplitud
    end
    filename = num2str(neuronID);
    axes('position',[0,0,1,1],'visible','off');
    text(.5, 0.97, sprintf('Neuron: %d Recording ele: %d', neuronID, recEle), ...
        'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
    print([path filename '_20'], '-dpng', '-r300');
    close(f)
end

