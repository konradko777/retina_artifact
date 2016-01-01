function mapping

electrodeMap=edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(1);
spacing = 30;
for i=1:64
    ElectrodesCoordinates(i,1) = electrodeMap.getXPosition(i);
    ElectrodesCoordinates(i,2) = electrodeMap.getYPosition(i);
end
radius = 1;
channel = 41;
adjacentEles = electrodeMap.getAdjacentsTo(channel,radius);
num2str(ElectrodesCoordinates(adjacentEles(2:end), :) ./ spacing);
positionMap = containers.Map(' 1  2', [0.1 0.6 0.2 0.2])
