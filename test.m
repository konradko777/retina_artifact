function test
    subplot(2,1,1)
    plot(1:10)
    markMovie()
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
    offset = 0;
    rectangle('Position', [x_min - offset, y_min - offset, ...
        width + 2*offset height + 3*offset], 'clipping', 'off', 'edgecolor', 'b', 'linewidth', 2);
    ylim(ylims);
    xlim(xlims);
end