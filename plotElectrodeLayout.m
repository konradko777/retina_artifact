% clear;
% javaaddpath('Vision.jar')


electrodeMap=edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(1);

for i=1:65
    ElectrodesCoordinates(i,1) = electrodeMap.getXPosition(i - 1);
    ElectrodesCoordinates(i,2) = electrodeMap.getYPosition(i - 1);
end

figure
plot(ElectrodesCoordinates(:,1), ElectrodesCoordinates(:,2),'b.' )

for i=1:65
    x = ElectrodesCoordinates(i,1);
    y = ElectrodesCoordinates(i,2);
    text(x + 2, y + 2, num2str(i-1))
end