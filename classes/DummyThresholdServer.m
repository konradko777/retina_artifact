classdef DummyThresholdServer < SpikeDetThresholdServer
    properties
        dummyAmp
        
    end
    methods
        function serverObj = DummyThresholdServer(dummyAmp)
            serverObj.dummyAmp = dummyAmp;
        end
        function threshold = giveThresholdForElectrodes(serverObj, stimEle, recEle)
            threshold = serverObj.dummyAmp;            
        end
    end
end