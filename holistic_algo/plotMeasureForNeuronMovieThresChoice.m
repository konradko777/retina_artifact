function plotMeasureForNeuronMovieThresChoice(measureMatrix, thresholdValues, ...
        artifactIDsMatrix, clusterArtifactNo, caxisLim, markSelectedMovie, ...
        selectedThresholds, markSelectedThresholds, detectedSpikesNo)
    %artifactIDsMatrix - in each cell vector of artifact IDs for given
    %clusterArtifactNo(int) - number of artifact taken from cluster file
    %caxisLim([min(int) max(int)]) - min and max value used while color mapping
    %selectedMovie(int) - amplitude chosen by algo
    %markSelectedMovie(bool) - whether to show on plot, which movie was
    %   chosen
    %selectedThresholds(array<ints> - indices of selected thresholds
    %markselectedThresholds - whether to mark selected thersholds
    %movie
    nOfArtsPerThres = getNumberOfArtifacts(artifactIDsMatrix);
    imagesc2(measureMatrix, caxisLim, selectedThresholds);
    setTickLabels(thresholdValues);
    setNumberOfArtifacts(nOfArtsPerThres);
    setNumberOfClustArt(thresholdValues, clusterArtifactNo);
    setNumberOfDetectedSpikes(thresholdValues, detectedSpikesNo);
    if markSelectedThresholds && selectedThresholds
        markThresholds(selectedThresholds);
    end
    if markSelectedMovie
        markMovie
    end
%     setTextLabels(measureMatrix)

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
    offset = 1;
    rectangle('Position', [x_min - offset, y_min - offset, ...
        width + 2*offset height + 3*offset], ...
        'clipping', 'off', 'edgecolor', 'b', 'linewidth', 2);

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
        'clipping', 'off', 'edgecolor', 'r', 'linewidth', 1.5);


end


function h = imagesc2 ( imgData, caxisLim, selectedThresholds )
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

function setNumberOfClustArt(thresholdValues, clusterArtifactNo)
    n = length(thresholdValues);
    axDist = n + 1.5;
    text((n+1) / 4, axDist, sprintf('Clust: %d', clusterArtifactNo), 'horizontalAlignment', 'center')

end

function setNumberOfDetectedSpikes(thresholdValues, detectedSpikesNo)
    n = length(thresholdValues);
    axDist = n + 1.5;
    text(3 * (n+1) / 4, axDist, sprintf('Spikes: %d', detectedSpikesNo), 'horizontalAlignment', 'center')

end
function setNumberOfArtifacts(nOfArtsVector)
    labels = cellstr(num2str(nOfArtsVector'));
    n = length(nOfArtsVector);
    axDist = n + 0.8;
    for i = 1:n
        text(i, axDist,  labels{i},'horizontalAlignment', 'center');
    end

end
function setTickLabels(values)
    labels = cellstr(num2str(values'));
    n = length(values);
    underAxDist = - 0.001;
    for i = 1:n
        text(-.02, i, labels{i},'horizontalAlignment', 'center');
        text(i,underAxDist,  labels{i},'horizontalAlignment', 'center');
    end
end

function setTextLabels(measureMatrix)
    n = length(measureMatrix);
    for i = 1:n
        for j = 1:n
            text(i,j, sprintf('%.2f', measureMatrix(i,j)), 'horizontalAlignment', 'center')
        end
    end
end

function nOfArtsPerThres = getNumberOfArtifacts(artifactIDsMatrix)
    nOfThres = length(artifactIDsMatrix);
    nOfArtsPerThres = zeros(1, nOfThres);
    for i = 1:nOfThres
        nOfArtsPerThres(i) = length(artifactIDsMatrix{i});    
    end
end

% 
% function plotMeasureForNeuronMovieThres(stableThresIndices)
% %     figure
% %     nThres = 8;
%     a = rand(8);
%     imagesc(a);
%     set(gca, 'ydir', 'normal')
%     r = rectangle('Position', [0.6 .3 .3 .3], 'clipping', 'off', 'edgecolor', 'r');
% %     set(r, 'clipping', 'off')
%     figure
%     subplot(1,2,1)
%     plot(1:10)
%     subplot(1,2,2)
%     plot(fliplr(1:10))
%     r = rectangle('Position', [-1 -1 12 12], 'clipping', 'off');
%     xlim([0 10])
%     ylim([0 10])
% %     axes('position',[0,0,1,1],'visible','off');
% %     text(.5, .5, 'asfsadfdasfa')
% %     xlim([0 1])
% %     ylim([0 1])
% %     rectangle('position', [.5 .5 .3 .3])
% end

