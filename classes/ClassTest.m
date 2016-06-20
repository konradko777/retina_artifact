function ClassTest()
%     spikeVec = [9 10 12 9 20 45];
    spikeVec = [8 8 0 0 0];
    idx = findFullEffIdx(spikeVec)
end


function fullEffIdx = findFullEffIdx(spikeVec)
    spikeMin = 15;
    spikeMax = 48;
    inRange = (spikeVec >= spikeMin) & (spikeVec <=spikeMax);
    firstIdx = find(inRange, 1);
    fullEffIdx = 0;
    if firstIdx
        i = firstIdx;
        while i < length(spikeVec)
            i = i + 1;
            if spikeVec(i) < spikeVec(i - 1)
                fullEffIdx = i;
                break
            end
        end
        if fullEffIdx == 0
            fullEffIdx = Inf;
        end
    else
        fullEffIdx = Inf;
    end
end