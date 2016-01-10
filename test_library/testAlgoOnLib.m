function resultStruct = testAlgoOnLib( algoHandle, testLibDict)
    for labelCell = keys(testLibDict)
        label = labelCell{1};
        if ~strcmp(label, '2outliers')
            continue
        end
        traces = testLibDict(label);
        resultStruct = algoHandle(traces);
        figure
        title(label);
        plotTracesGroups(resultStruct, traces);
    end
end

function plotTracesGroups(resultStruct, traces)
    artIDs = resultStruct.artifactIDs;
    excludedIDs = resultStruct.excluded;
    spikeIDs = resultStruct.spikes;
    hold on
    plot(traces(spikeIDs, :)', 'color', 'g')
    plot(traces(artIDs, :)', 'color', 'r')
    plot(traces(excludedIDs, :)', 'color', 'k', 'linewidth', 2)
end

