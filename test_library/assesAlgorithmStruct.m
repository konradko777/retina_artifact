function assesAlgorithmStruct( algoHandle, movieEleDict)
    tracesDict = getTestTraces();
    for labelCell = keys(movieEleDict)
        label = labelCell{1};
        traces = tracesDict(label);
        movieEle = movieEleDict(label);
        resultStruct = algoHandle(traces); %% tutaj resultStruct

        clustFile = createClustFileName(movieEle(2));
        patternNo = movieEle(2); %patternNo moze byc odmienny, zczytac z global recording ele...
        clustArtIDs = getArtIDsFromClustFile(clustFile, patternNo, movieEle(1));
        figure
        suptitle(label)
        subplot(3,1,1)
        title('Cluster File')
        plotArtifacts(traces, clustArtIDs)
        subplot(3,1,2)
        title('nDRWPruning Algo')
        plotTracesFromResultStruct(traces, resultStruct)
        subplot(3,1,3)
        title('Comparison')
        plotComparison(clustArtIDs, resultStruct);
    end
end


function clustFile = createClustFileName(electrode)
    global NEURON_CLUST_FILE_MAP ELE_NEURON_MAP
    neuronID = ELE_NEURON_MAP(electrode);
    clustFile = NEURON_CLUST_FILE_MAP(neuronID);
end

function plotComparison(clustArtIDs, algoStruct)
    imgMatrix = zeros(2,50);
    imgMatrix(1, clustArtIDs) = 1;
    imgMatrix(2, algoStruct.artifactIDs) = 1;
    imgMatrix(2, algoStruct.excluded) = -1;
    %dodac -1 dla wykluczonych
    image(imgMatrix, 'CDataMapping', 'scaled');
    caxis([-1 1])
    myColormap = [0 0 0; 0 1 0; 1 0 0];
    daspect([1 1 1])
    colormap(myColormap);
    hold on;
%     set(gca,'Ydir','Normal')
    
    line(xlim, [1.5 1.5], 'color', 'k', 'linewidth', 2);
    for i = 1.5:50.5
        line([i i], [0 2.5], 'color', 'k', 'linewidth', 2);
    end
%     set(gca, 'Xtick', 1.5:50.5)
%     set(gca, 'Ytick', 1.5)
%     set(gca, 'GridLineStyle', '-');
%     set(gca, 'MinorGridLineStyle', '-');
%     grid('on');
end

function plotArtifacts(traces, artefactIDs)
    hold on
    plot(traces', 'color', 'g')
    plot(traces(artefactIDs, :)', 'color', 'r')
end

function plotTracesFromResultStruct(traces, resultStruct)
    hold on
    plot(traces', 'color', 'g')
    plot(traces(resultStruct.artifactIDs, :)', 'color', 'r')
    plot(traces(resultStruct.excluded, :)', 'color', 'k', 'linewidth', 2)

end