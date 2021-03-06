function [ mergedMat ] = mergeMeasureMatrices( normedMat, rawMat)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    indices = 1;
    normedRawMat = normalizeRawMat(rawMat);
    mergedMat = zeros(size(normedMat));
    mergedMat = insertUpperTriangle(mergedMat, normedRawMat);
    mergedMat = insertLowerTriangle(mergedMat, normedMat);

end


function normed = normalizeRawMat(rawMat)
    nMovies = size(rawMat,1);
    max_ = max(rawMat(:));
    min_ = min(rawMat(:));
    normed = (2*rawMat - (min_ + max_)) / (max_ - min_);

end

function insertedMat = insertUpperTriangle(outMat, sourceMat)
    %assumed same shaped, 3d matrices
    n = size(outMat, 1);
    for i = 1:n
        mat2D = squeeze(sourceMat(i, :, :));
        idxToInsert = triu(mat2D) ~= 0;
        outMat(i, idxToInsert) = mat2D(idxToInsert);
    end
    insertedMat = outMat;
end

function insertedMat = insertLowerTriangle(outMat, sourceMat)
    %assumed same shaped, 3d matrices
    n = size(outMat, 1);
    for i = 1:n
        mat2D = squeeze(sourceMat(i, :, :));
        idxToInsert = tril(mat2D) ~= 0;
        outMat(i, idxToInsert) = mat2D(idxToInsert);
    end
    insertedMat = outMat;
end