function res = sigmoidalFunc(coeffs, xdata)
    res = (1 +  exp(-coeffs(1) * xdata + coeffs(2))).^-1; 

end