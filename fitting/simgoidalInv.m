function x = sigmoidalInv(coeffs, y)
    x = (log(1/y -1) - coeffs(2)) / (-coeffs(1));
end