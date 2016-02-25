function ElectrodesCoordinates = getElectrodeCoord(electrodeMap)
    N_of_ele = electrodeMap.getNumberOfElectrodes();
    ElectrodesCoordinates = zeros(N_of_ele -1, 2);
    for i = 1:N_of_ele-1
        ElectrodesCoordinates(i,1) = electrodeMap.getXPosition(i);
        ElectrodesCoordinates(i,2) = electrodeMap.getYPosition(i);
    end
end