function electrodeToRelPosMap = createPositionDictForAdjEles(ElectrodeNumber, electrodeMap)
    spacing = 30;
    ElectrodesCoordinates = getElectrodeCoord(electrodeMap);
    adjacentEles = electrodeMap.getAdjacentsTo(ElectrodeNumber, 1);
    centerPos = ElectrodesCoordinates(ElectrodeNumber, :);
    centerPos = repmat(centerPos, length(adjacentEles), 1); 
    relativePos = num2str((ElectrodesCoordinates(adjacentEles, :) - centerPos) ...
        ./ spacing);
    relativePos = cellstr(relativePos);
    electrodeToRelPosMap = containers.Map(adjacentEles, relativePos);
end




