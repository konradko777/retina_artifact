function measureMat = computeMeasureMat(meanArtifacts, cmpMeasureVecHandle)
    %cmpMeasureVecHandle(vec1, vec2)
    N = size(meanArtifacts, 1);
    measureMat = zeros(N);
    for i = 1:N
        for j = 1:N
            measureMat(i, j) = cmpMeasureVecHandle(meanArtifacts(i, :), meanArtifacts(j, :));
        end
    end
end
