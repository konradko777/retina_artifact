classdef DummyThresholdServer < SpikeDetThresholdServer
    properties
        dummyAmp
        
    end
    methods
        function serverObj = DummyThresholdServer(dummyAmp)
            serverObj.dummyAmp = dummyAmp;
        end
        function threshold = giveThresholdForElectrodesMovie(serverObj, stimEle, recEle, movie)
            threshold = serverObj.dummyAmp;            
        end
    end
end