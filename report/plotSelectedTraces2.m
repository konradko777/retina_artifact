function plotSelectedTraces2(traces, selectedIDs, color, linewidth)
    grid on
    plot(traces(selectedIDs, :)', 'color', color, 'linewidth', linewidth)
end


