classdef StimAmpSelector < handle
    properties 
        desiredEff
    end
    
    methods
        function selectorObj = StimAmpSelector(desiredEff)
            selectorObj.desiredEff = desiredEff;
        end
        function optimalAmp = selectAmplitude(selectorObj, amplitudes, efficacies)
            coefficients = lsqcurvefit(@selectorObj.sigmoidalFunc, [1, 0], amplitudes, efficacies);
            optimalAmp = selectorObj.sigmoidalInv(coefficients, selectorObj.desiredEff);
        end
        
        function res = sigmoidalFunc(selectorObj, coeffs, xdata)
            res = (1 +  exp(-coeffs(1) * xdata + coeffs(2))).^-1; 
        end
        
        function x = sigmoidalInv(selectorObj, coeffs, y)
            x = (log(1/y -1) - coeffs(2)) / (-coeffs(1));
        end
    end
end
