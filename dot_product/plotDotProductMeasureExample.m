function plotDotProductMeasure(measureMatrix, thresholdValues, artifactIDsMatrix)
    nOfArtsPerThres = getNumberOfArtifacts(artifactIDsMatrix);
    imagesc2(measureMatrix);
    setTickLabels(thresholdValues);
    setNumberOfArtifacts(nOfArtsPerThres);

%     setTextLabels(measureMatrix)

end
function h = imagesc2 ( imgData )
    % a wrapper for imagesc, with some formatting going on for nans

    % plotting data. Removing and scaling axes (this is for image plotting)
    % figure

    h = imagesc(imgData);
    % hold on
    % axis image off
    nx = size(imgData, 1);
    ny = size(imgData, 2);
    % setting alpha values
    set(h, 'AlphaData', ~isnan(imgData))
    set(gca, 'Color', [0.5, 0.5, 0.5])
    colormap Summer
    set(gca, 'ydir', 'normal')
    set(gca,'xtick', linspace(0.5,nx+0.5,nx+1), 'ytick', linspace(0.5,ny+.5,ny+1));
    set(gca, 'xticklabel', [])
    set(gca, 'yticklabel', [])
    set(gca,'xgrid', 'on', 'ygrid', 'on','gridlinestyle', '-', 'xcolor', 'k', 'ycolor', 'k')
    caxis([-1, 1])
end

function setNumberOfArtifacts(nOfArtsVector)
    labels = cellstr(num2str(nOfArtsVector'));
    n = length(nOfArtsVector);
    axDist = n + 0.8;
    for i = 1:n
        text(i, axDist,  labels{i},'horizontalAlignment', 'center', 'fontsize', 20);
    end

end
function setTickLabels(values)
    labels = cellstr(num2str(values'));
    n = length(values);
    underAxDist = - 0.001;
    for i = 1:n
        text(-.02, i, labels{i},'horizontalAlignment', 'center', 'fontsize', 20);
        text(i,underAxDist,  labels{i},'horizontalAlignment', 'center', 'fontsize', 20);
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
    nOfThres = size(artifactIDsMatrix,2);
    nOfArtsPerThres = zeros(1, nOfThres);
    for i = 1:nOfThres
        nOfArtsPerThres(i) = length(artifactIDsMatrix{i});    
    end
end