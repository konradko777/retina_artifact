function [ output_args ] = mergeMeasureMatrices( normedMat, rawMat)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    indices = 1;
    rawMat = normalizeRawMat(rawMat)
    

end


function normed = normalizeRawMat(rawMat)
    max_ = max(rawMat(:));
    min_ = min(rawMat(:));
    normed = (2*rawMat - (min_ + max_)) / (max_ - min_);

end
