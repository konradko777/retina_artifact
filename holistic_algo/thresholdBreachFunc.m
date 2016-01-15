function simmilarityBreach = thresholdBreachFunc(simValuesVec, breachThreshold)
    n = length(simValuesVec);
    for i=1:n
        val1 = simValuesVec(i);
        for j = i+1:n
            val2 = simValuesVec(j);
            if abs(val1 - val2) > breachThreshold
                simmilarityBreach = true;
                return
            end
        end
    end
    simmilarityBreach = false;
end