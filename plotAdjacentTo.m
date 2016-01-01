function plotAdjacentTo(ElectrodeNumber, PatternNumber, MovieNumber, ...
        tracesNumbers, plotOptions)
    electrodeMap=edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(1);
    DataPath='data003';
    TracesNumberLimit=50;
    EventNumber=0;
    [DataTraces, ArtifactDataTraces, Channels] = ...
        NS_ReadPreprocessedData(DataPath,DataPath,0,PatternNumber,MovieNumber,...
        TracesNumberLimit,EventNumber);
    [adjacentEles, electrodeToRelPosMap, relPosPlotPosMap] = ...
        createMappings(electrodeMap, ElectrodeNumber);
    hexagonalPlot(adjacentEles, DataTraces, electrodeToRelPosMap, ...
        relPosPlotPosMap, tracesNumbers, plotOptions)
end

function ElectrodesCoordinates = getElectrodeCoord(electrodeMap)
    N_of_ele = electrodeMap.getNumberOfElectrodes();
    ElectrodesCoordinates = zeros(N_of_ele -1, 2);
    for i = 1:N_of_ele-1
        ElectrodesCoordinates(i,1) = electrodeMap.getXPosition(i);
        ElectrodesCoordinates(i,2) = electrodeMap.getYPosition(i);
    end
end
function [adjacentEles, electrodeToRelPosMap, relPosPlotPosMap] = ...
        createMappings(electrodeMap, ElectrodeNumber)
    subplotWidth = 0.3;
    subplotHeight = 0.3;
    spacing = 30;
    ElectrodesCoordinates = getElectrodeCoord(electrodeMap);
    adjacentEles = electrodeMap.getAdjacentsTo(ElectrodeNumber, 1);
    centerPos = ElectrodesCoordinates(ElectrodeNumber, :);
    centerPos = repmat(centerPos, length(adjacentEles), 1); 
    relativePos = num2str((ElectrodesCoordinates(adjacentEles, :) - centerPos) ...
        ./ spacing);
    relativePos = cellstr(relativePos);
    electrodeToRelPosMap = containers.Map(adjacentEles, relativePos);
    relativePos = {'-1  2'; ' 1  2';'-2  0';' 0  0';' 2  0';'-1 -2';' 1 -2'};
    positions = {[0.2, 0.67, subplotWidth, subplotHeight]
                 [0.55, 0.67, subplotWidth, subplotHeight]
                 [0.03 0.35 subplotWidth, subplotHeight]
                 [0.35 0.35 subplotWidth, subplotHeight]
                 [0.67 0.35 subplotWidth, subplotHeight]
                 [0.2, 0.03, subplotWidth, subplotHeight]
                 [0.55, 0.03, subplotWidth, subplotHeight]
                 };
    relPosPlotPosMap = containers.Map(relativePos, positions);
end

function [] = hexagonalPlot(adjacentEles, DataTraces, electrodeToRelPosMap, relPosPlotPosMap, tracesNumbers, plotOptions)
    %TODO: do ogarniecia wybor kanalow do skalowania wykresu
    if ~ischar(tracesNumbers)
        selectedDataTraces = DataTraces(tracesNumbers, :, :);
    else
        selectedDataTraces = DataTraces;
    end
    temp_ = DataTraces(:, adjacentEles, :);
    vectorizedDataTraces = temp_(:);
    min_ = min(vectorizedDataTraces);
    max_ = max(vectorizedDataTraces);
    
    for electrode = adjacentEles'
        relPos = electrodeToRelPosMap(electrode);
        plotPos = relPosPlotPosMap(relPos);
        subplot('position', plotPos);
        hold on
        traces = squeeze(selectedDataTraces(:,electrode,:));
        plot(traces', plotOptions)
        ylim([min_, max_])
        if ~strcmp(relPos, ' 1 -2')
            set(gca, 'XTickLabel', []);
        end
        text(0.9, 0.9,num2str(electrode), 'units', 'normalized')
    end
end
