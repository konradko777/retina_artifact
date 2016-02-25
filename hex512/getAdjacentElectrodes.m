function adjacentEles = getAdjacentElectrodes(electrode, mapObject)
    adjacentEles = mapObject.getAdjacentsTo(electrode, 1);

end