function traces = assesAlgorithm( algoHandle, label )
    movieEleDict = createTestTracesDict();
    tracesDict = getTestTraces();
    traces = tracesDict(label);
    movieEle = movieEleDict(label);
    algoArtIDs = algoHandle(traces);
    
    clustFile = createClustFileName(movieEle(2));
    patternNo = movieEle(2); %patternNo moze byc odmienny, zczytac z global recording ele...
    clustArtIDs = getArtIDsFromClustFile(clustFile, patternNo, movieEle(1));
    figure
    subplot(3,1,1)
    plotArtifacts(traces, clustArtIDs)
    subplot(3,1,2)
    plotArtifacts(traces, algoArtIDs)
    subplot(3,1,3)
    plotComparison(clustArtIDs, algoArtIDs);
end


function clustFile = createClustFileName(electrode)
    global NEURON_CLUST_FILE_MAP ELE_NEURON_MAP
    neuronID = ELE_NEURON_MAP(electrode);
    clustFile = NEURON_CLUST_FILE_MAP(neuronID);
end

function plotComparison(clustArtIDs, algoArtIDs)
    imgMatrix = zeros(2,50);
    imgMatrix(1, clustArtIDs) = 1;
    imgMatrix(2, algoArtIDs) = 1;
    image(imgMatrix, 'CDataMapping', 'scaled');
    caxis([-1 1])
    daspect([1 1 1])
    colormap('gray');
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