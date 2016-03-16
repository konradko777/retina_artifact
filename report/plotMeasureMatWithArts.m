function plotMeasureMatWithArts(traces, artIDs, measureMat, currentThreshold, thresholds, sampleLim, colorLim)
    artTraces = traces(artIDs, :);
    meanArt = mean(artTraces);
    tracesSubtracted = traces - repmat(meanArt, size(traces, 1), 1);
    
    subplot('position', [.05 .55 .4 .4])
    hold on
    plot(traces', 'color', [.3 .3 .3])
    plot(traces(artIDs, :)', 'color', 'r')
    set(gca, 'xticklabel', '')
    
    subplot('position', [.05 .1 .4 .4])
    plot(tracesSubtracted', 'color', [.3 .3 .3])
    

    
    subplot('position', [.5 .1 .48 .85])
    plotMeasureSimpleReport(measureMat, currentThreshold, thresholds, colorLim)
    title('Dissimilarity measure for artifact models', 'fontsize', 20)
end 