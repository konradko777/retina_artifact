classdef QTThresholdServer < SpikeDetThresholdServer
    properties
        thresDict
    end
    methods
        function serverObj = QTThresholdServer()
            serverObj.thresDict = containers.Map('KeyType', 'char', 'ValueType', 'single');
        end
        function saveThresForElectrodesMovie(servObj, stimEle, recEle, movie, QT)
            charKey = sprintf('%d %d %d', stimEle, recEle, movie);
            servObj.thresDict(charKey) = -QT * .8;           
        end
        function threshold = giveThresholdForElectrodesMovie(serverObj, stimEle, recEle, movie)
            charKey = sprintf('%d %d %d', stimEle, recEle, movie);
            threshold = serverObj.thresDict(charKey);
        end
    end
end