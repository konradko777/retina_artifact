function plotMeasureForNeuron(neuronID, movies, thresholds, measureMat, fullArtifactIDsMatrix, fullClustArtNumVec)
    global NEURON_REC_ELE_MAP
    recEle = NEURON_REC_ELE_MAP(neuronID);
    [min_, max_] = getMinMax(measureMat);
    f = figure();
    set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 40 25])
    set(gcf, 'InvertHardCopy', 'off');
    
    for i = 1:length(movies)
        subplot(4,6,i)
        plotMeasureForNeuronMovie(squeeze(measureMat(i, :, :)), thresholds, fullArtifactIDsMatrix{i}, fullClustArtNumVec(i), [min_, max_])
%         title(movieNumber); %dodac odczyt amplitud
    end
%     filename = num2str(neuronID);
%     path = 'C:\studia\dane_skrypty_wojtek\ks_functions\holistic_algo\';
%     axes('position',[0,0,1,1],'visible','off');
%     text(.5, 0.97, sprintf('Neuron: %d Recording ele: %d', neuronID, recEle), ...
%         'horizontalAlignment', 'center', 'fontsize', 14, 'fontweight', 'bold')
%     print([path filename], '-dpng', '-r300');
%     close(f)
end

function [min_, max_] = getMinMax(measureMat)
    vectorized = measureMat(:);
    min_ = min(vectorized);
    max_ = max(vectorized);

end