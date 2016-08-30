classdef QTThresholdServer < SpikeDetThresholdServer
% A class that is responsible for receiving information from art classifier
% object about largest QT in stability island and creating spike detection
% threshold based on that.
    properties
        thresDict
        scalingOfQT
    end
    methods
        function serverObj = QTThresholdServer(scalingOfQT)
        % Constructor of QTThresholdServer class initializing scalingOFQT
        % and thresDict. The first one is multiplier factor used to
        % determine spike detection threshold with regard to largest QT.
        % The other field is initialized as an empty containers.Map object 
        % with keys of type char and values to float type. It stores 
        % information about spike detection threshold with for SE-RE
        % pair and stimulation current amplitude.
            serverObj.thresDict = containers.Map('KeyType', 'char', 'ValueType', 'single');
            serverObj.scalingOfQT = scalingOfQT;
        end
        function saveThresForElectrodesMovie(serverObj, stimEle, recEle, movie, QT)
        % Puts information about spike detection threshold for 
        % SE-RE-amplitude combination using known largest quantization
        % threshold into servObj.thresDict map object.
        % Input:
        %     stimEle(Int): stimulation electrode ID.
        %     recEle(Int): recording electrode ID.
        %     movie(Int): amplitude integer representation
        %     QT(Float): largest quantization threshold in stability island
            charKey = sprintf('%d %d %d', stimEle, recEle, movie);
            serverObj.thresDict(charKey) = -QT * serverObj.scalingOfQT;           
        end
        function threshold = giveThresholdForElectrodesMovie(serverObj, stimEle, recEle, movie)
        % Returns spike detection threshold for specified SE-RE-amplitude
        % condition.
        % Input:
        %     stimEle(Int): stimulation electrode ID.
        %     recEle(Int): recording electrode ID.
        %     movie(Int): amplitude integer representation
        % Output:
        %     threshold(Float): spike detection threshold.
            charKey = sprintf('%d %d %d', stimEle, recEle, movie);
            threshold = serverObj.thresDict(charKey);
        end
    end
end