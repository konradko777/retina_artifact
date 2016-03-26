function plotMeasureMatWithArts(traces, artIDs, measureMat, currentThreshold, thresholds, sampleLim, colorLim)
    artTraces = traces(artIDs, :);
    meanArt = mean(artTraces);
    tracesSubtracted = traces - repmat(meanArt, size(traces, 1), 1);
    
    subplot('position', [.05 .55 .4 .4])
    hold on
    grid on
    plot(traces', 'color', [.3 .3 .3])
    plot(traces(artIDs, :)', 'color', 'r', 'linewidth', 2)
    plot(meanArt, 'g--', 'linewidth', 3)
    title('A. Raw signal', 'fontsize', 20)
    set(gca, 'xticklabel', '')
    
    subplot('position', [.05 .1 .4 .4])
    hold on
    grid on
    plot(tracesSubtracted', 'color', [.3 .3 .3])
    plot(tracesSubtracted(artIDs, :)', 'color', 'r', 'linewidth', 2)
    plot(zeros(size(meanArt)), 'g--', 'linewidth', 3)
    title('B. Raw signal - artifact model', 'fontsize', 20)

    
    subplot('position', [.5 .1 .48 .85])
    plotMeasureSimpleReport(measureMat, currentThreshold, thresholds, colorLim)
    colorbar
    title('C. Dissimilarity measure for artifact models', 'fontsize', 20)
end 