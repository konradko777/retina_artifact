function amp = findSpikeAmpFromEI(electrode, ei)
%need to add 1 to electrode number to match 513 format of EI
    amp = min(ei(electrode + 1, :));
end