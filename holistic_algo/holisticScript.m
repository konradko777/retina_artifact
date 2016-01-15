% addJava
% setGlobals
tbf = @(valVec)thresholdBreachFunc(valVec, 1);
% test([1 1 1], 1:3, 1, tbf)
a = ones(4);
% a(4,:) = [3 3 3 3];
% a
a(3, 2) = 3;
% a(3, 2) = 3;
a
getMinimalStableThresholdDiff(a, 1:4, tbf, 3)