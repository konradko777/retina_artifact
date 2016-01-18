function similarityBreach = thresholdBreachFunc(simValuesVec, breachThreshold)
    similarityBreach = any(simValuesVec > breachThreshold);
end