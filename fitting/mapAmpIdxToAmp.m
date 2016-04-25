function amp = mapAmpIdxToAmp(ampIdx, mapping)
    if ampIdx
        amp = mapping(ampIdx);
    else
        amp = 0;
    end
end