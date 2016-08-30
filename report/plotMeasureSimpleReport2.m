function plotMeasureSimpleReport2(measureMatrix, currentThreshold, currentThreshold2, thresholdValues, caxisLim)
    %artifactIDsMatrix - in each cell vector of artifact IDs for given
    %clusterArtifactNo(int) - number of artifact taken from cluster file
    %caxisLim([min(int) max(int)]) - min and max value used while color mapping
    %selectedMovie(int) - amplitude chosen by algo
    %markSelectedMovie(bool) - whether to show on plot, which movie was
    %   chosen
    %selectedThresholds(array<ints> - indices of selected thresholds
    %markselectedThresholds - whether to mark selected thersholds
    %movie
    FONTSIZE = 18;
    imagesc2(measureMatrix, caxisLim);
    setTickLabels(thresholdValues, FONTSIZE - 5);
    middle = length(thresholdValues) / 2 + .5;
    xlabel('QT used', 'fontsize', FONTSIZE, 'position', [middle -.2 0])
    ylabel('QT used', 'fontsize', FONTSIZE, 'position', [-.2 middle 0])
    markThresholds(currentThreshold)
    markThresholds2(currentThreshold2)

end

function markMovie()
    xlims = xlim;
    ylims = ylim;
    x_min = xlims(1);
    x_max = xlims(2);
    y_min = ylims(1);
    y_max = ylims(2);
    width = x_max - x_min;
    height = y_max - y_min;
    offset = 3;
    rectangle('Position', [x_min - offset, y_min - offset, ...
        width + 2*offset height + 3*offset], ...
        'clipping', 'off', 'edgecolor', 'b', 'linewidth', 2);

end


function markThresholds2(selectedThresholds)
    if isempty(selectedThresholds);
        return
    end
    nThres = length(selectedThresholds);
    XOFFSET = .5;
    YPOS = -.3;
    YDIM = .8;
    FIRST = selectedThresholds(1);
    rectangle('Position', [YPOS (FIRST - XOFFSET) YDIM (nThres)], ...
        'clipping', 'off', 'edgecolor', 'y', 'linewidth', 1.5);
end
    
function markThresholds(selectedThresholds)
    if isempty(selectedThresholds);
        return
    end
    nThres = length(selectedThresholds);
    XOFFSET = .5;
    YPOS = -.3;
    YDIM = .7;
    FIRST = selectedThresholds(1);
    rectangle('Position', [(FIRST - XOFFSET) YPOS (nThres) YDIM], ...
        'clipping', 'off', 'edgecolor', 'g', 'linewidth', 1.5);
end


function h = imagesc2 ( imgData, caxisLim)
    % a wrapper for imagesc, with some formatting going on for nans

    % plotting data. Removing and scaling axes (this is for image plotting)
    % figure
    h = imagesc(imgData);
    % hold on
    % axis image off
    nx = size(imgData, 1);
    ny = size(imgData, 2);
    % setting alpha values
%     r = rectangle('Position', [3 .1 1 1], 'clipping', 'off', 'edgecolor', 'r');
%     set(h, 'AlphaData', ~isnan(imgData))
    set(gca, 'Color', [0.5, 0.5, 0.5])
    colormap(jet(256))
    set(gca, 'ydir', 'normal')
    set(gca,'xtick', linspace(0.5,nx+0.5,nx+1), 'ytick', linspace(0.5,ny+.5,ny+1));
    set(gca, 'xticklabel', [])
    set(gca, 'yticklabel', [])
    set(gca,'xgrid', 'on', 'ygrid', 'on','gridlinestyle', '-', 'xcolor', 'k', 'ycolor', 'k')
    caxis(caxisLim)
end

function setTickLabels(values, fontsize)
    labels = cellstr(num2str(values'));
    n = length(values);
    underAxDist = .1;
    for i = 1:n
        text(underAxDist , i, labels{i},'horizontalAlignment', 'center', 'fontsize', fontsize);
        text(i,underAxDist,  labels{i},'horizontalAlignment', 'center', 'fontsize', fontsize);
    end
end

