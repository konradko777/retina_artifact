classdef StimAmpSelector < handle
% A class which is responsible for selection of optimal stimulation current
% amplitude when provided with stimulation efficacy as function of
% stimulation current. This implementation uses fit to sigmoidal function
% to determine proper current amplitude.
    properties 
        desiredEff % mind that for sigmoidal function 1 is achieved for
                   % infinity, therefor approximation strictly smaller than
                   % 1 should be chosen.
    end
    
    methods
        function selectorObj = StimAmpSelector(desiredEff)
        % Creates StimAmpSelector object and initializes desiredEff
        % variable.
        % Input:
        %     desiredEff(Float): a number valued from 0 to 1 based on which
        %         optimal stimulation current is selected. Mind that 1 is
        %         achieved for ininite current.
            selectorObj.desiredEff = desiredEff;
        end
        function optimalAmp = selectAmplitude(selectorObj, amplitudes, efficacies)
            opts = optimset('Display','off');
            coefficients = lsqcurvefit(@selectorObj.sigmoidalFunc, [1, 0], amplitudes, ...
                efficacies, [-Inf, -Inf], [Inf, Inf], opts);
            optimalAmp = selectorObj.sigmoidalInv(coefficients, selectorObj.desiredEff);
        end
        
        function res = sigmoidalFunc(selectorObj, coeffs, xdata)
        % Compute value of sigmoidal function (which is used to approximate
        % the shape stimulation efficacy function).
        % Input:
        %     coeffs(Vector<Float>): a two element vector with coefficients
        %         of sigmoidal function.
        %     xdata(Vector<Float>): x-es on which function operates. In
        %         algorithm context these are stimulation current
        %         amplitudes.
            res = (1 +  exp(-coeffs(1) * xdata + coeffs(2))).^-1; 
        end
        
        function x = sigmoidalInv(selectorObj, coeffs, y)
        % Inverse sigmoidal function used to determine amplitude
        % corresponding to selectorObj.desiredEff efficiency.
        % Input:
        %     coeffs(Vector<Float>): a two element vector with coefficients
        %         of sigmoidal function.
        %     y(Float): Valued from 0 to 1. Efficiency for which we want to 
        %         know corresponding amplitude
        % Output:
        %     x(Float): amplitude corresponding to y efficiency.
            x = (log(1/y -1) - coeffs(2)) / (-coeffs(1));
        end
    end
end
