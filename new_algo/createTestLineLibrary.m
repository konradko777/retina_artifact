function [ lineLibrary] = createTestLineLibrary
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    spike = ones(1,70);
    artifact = ones(1,70) * 30;
    outlier = ones(1,70) * 60;
    randoms = (rand(50,1) - .5) * 10;
    randoms = repmat(randoms, 1, 70);
    lineLibrary = containers.Map;
    lineLibrary('50perc') = [repmat(spike, 25, 1); repmat(artifact,25, 1)] + randoms;
    lineLibrary('1outlier') = [repmat(spike, 25, 1);
                               repmat(artifact,24, 1);
                               outlier] + randoms;
    lineLibrary('10perc') = [repmat(spike, 5, 1); repmat(artifact,45, 1)] + randoms;
    lineLibrary('90perc') = [repmat(spike, 45, 1); repmat(artifact,5, 1)] + randoms;
end

