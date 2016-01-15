function diffMeasure = cmpDiffMeasureVec(vec1, vec2)
    diffMeasure = sum(abs((vec1 - vec2)));
end