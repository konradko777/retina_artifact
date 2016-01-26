function plotSelectedTraces(traces, selectedIDs, color)
    plot(traces(selectedIDs, :)', 'color', color)

end