function h = imagesc2 ( img_data )
% a wrapper for imagesc, with some formatting going on for nans

% plotting data. Removing and scaling axes (this is for image plotting)
h = imagesc(img_data);
% axis image off
nx = 8;
ny = 8;
% setting alpha values
set(h, 'AlphaData', ~isnan(img_data))
set(gca, 'Color', [0.5, 0.5, 0.5])
colormap Summer
set(gca, 'ydir', 'normal')
set(gca,'xtick', linspace(0.5,nx+0.5,nx+1), 'ytick', linspace(0.5,ny+.5,ny+1));
set(gca, 'xticklabels', [])
set(gca,'xgrid', 'on', 'ygrid', 'on','gridlinestyle', '-', 'xcolor', 'k', 'ycolor', 'k')
end


function tickLabels = setTickLabels(values)
    labels = cellstr(num2str(values'));
    n = length(values);
    dl = 1/n;
    underAxDist = 0.1;
    startPos = dl/2;
    textPositions = startPos:dl:1;
    tickLabels = textPositions;
    figure
    for i = 1:n
        text(-underAxDist, textPositions(i), labels{i});
        text(textPositions(i),-underAxDist,  labels{i});
    end
end