classdef DummyThresholdServer < SpikeDetThresholdServer
% A simple spike detector threshold server class returning same amplitude
% for each stimulation electrode-recording electrode pair
    properties
        dummyAmp
    end
    methods
        function serverObj = DummyThresholdServer(dummyAmp)
        % Specifies what amplitude should be returned by object.
        % Input:
        %     dummyAmp(Float): amplitude that will be used in spike
        %         detection step. Same for all alectrodes and amplitudes.
            serverObj.dummyAmp = dummyAmp;
        end
        function threshold = giveThresholdForElectrodesMovie(serverObj, stimEle, recEle, movie)
        % Returns serverObj.dummyAmp field as spike detection threshold for
        % all SE-RE pairs. Information about electrodes and stimulation
        % current ID (movie) is not used.
        % Input:
        %     stimEle(Int): integer representation of electrode used 
        %         to stimulate retina.
        %     movie(Vector<Int>): integer representation of current amplitude
        %         used to stimulate retina.
        %     recEle(Int): integer representation of electrode from which the
        %         voltage was recorded.
        % Output:
        %     threshold(Float): spike detection threshold.
            threshold = serverObj.dummyAmp;            
        end
    end
end