function plotSelectedTraces(traces, selectedIDs, color)
    grid on
    plot(traces(selectedIDs, :)', 'color', color)

end