function similarityBreach = thresholdBreachFunc(simValuesVec, breachThreshold)
    if any(isnan(simValuesVec))
        similarityBreach = 1;
    else
        similarityBreach = any(simValuesVec > breachThreshold);
    end
end