function plotMeasureMatWithArts3(traces, artIDs, artIDs2, measureMat, currentThreshold, ...
        currentThreshold2, thresholds, sampleLim, colorLim, thres1coord, thres2coord, diffYLim)
    artTraces = traces(artIDs, :);
    meanArt = mean(artTraces);
    artTraces2 = traces(artIDs2, :);
    meanArt2 = mean(artTraces2);
%     tracesSubtracted = traces - repmat(meanArt, size(traces, 1), 1);
    
    HEIGHT = .24;
    TITLE_FONT_SIZE = 18;
    subplot('position', [.05 .69 .4 HEIGHT])
    hold on
    grid on
    plot(traces', 'color', [.3 .3 .3])
    plot(traces(artIDs, :)', 'color', 'r', 'linewidth', 2)
    plot(meanArt, 'g--', 'linewidth', 3)
    xlim([0,50])
    plotThresLine(thres1coord, thresholds(currentThreshold), 'g')
    title(sprintf('A. Classification for threshold %d', thresholds(currentThreshold)), 'fontsize', TITLE_FONT_SIZE)
    set(gca, 'xticklabel', '')
    set(gca, 'fontsize', 17)
    
    
    subplot('position', [.05 .37 .4 HEIGHT])
    hold on
    grid on
    plot(traces', 'color', [.3 .3 .3])
    plot(traces(artIDs2, :)', 'color', 'r', 'linewidth', 2)
    plot(meanArt2, 'y--', 'linewidth', 3)
    plotThresLine(thres2coord, thresholds(currentThreshold2), 'y')
    title(sprintf('B. Classification for threshold %d', thresholds(currentThreshold2)), 'fontsize', TITLE_FONT_SIZE)
    set(gca, 'xticklabel', '')
    set(gca, 'fontsize', 15)
    
    subplot('position', [.05 .05 .4 HEIGHT])
    hold on
    grid on
    X = [1:length(meanArt), length(meanArt):-1: 1];
    Y = [meanArt2 - meanArt, zeros(1, length(meanArt))];
    fill(X,Y, 'b')
    plot(zeros(size(meanArt)), 'g--', 'linewidth', 4)
    plot(meanArt2 - meanArt, 'y--', 'linewidth', 4)
    title('C. Dissimilarity function for artifact models', 'fontsize', TITLE_FONT_SIZE)
    set(gca, 'xtick', 0:10:70)
    set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
    set(gca, 'fontsize', 15)
    xlabel('t[ms]', 'fontsize', 16)
    xlabh = get(gca,'XLabel');
    set(xlabh,'Position', [35 -16.5 0])
    ylim(diffYLim)

%     set(xlabh,'Position',get(xlabh,'Position') + [0 .4 0])
%     plot(meanArt2, 'b--', 'linewidth', 2)
%     plot(tracesSubtracted', 'color', [.3 .3 .3])
%     plot(tracesSubtracted(artIDs, :)', 'color', 'r', 'linewidth', 2)
%     plot(zeros(size(meanArt)), 'g--', 'linewidth', 3)
%     title('B. Raw signal - artifact model', 'fontsize', 20)

    
    subplot('position', [.5 .1 .48 .85])
    plotMeasureSimpleReport2(measureMat, currentThreshold, currentThreshold2, ...
        thresholds, colorLim)
    colorbar('fontsize', 20)
    title('D. Dissimilarity measure for artifact models', 'fontsize', TITLE_FONT_SIZE)
end 


function plotThresLine(coords, length, color)
    line([coords(1) coords(1)], [coords(2) coords(2) - length], 'color', color, 'linewidth', 4)
end