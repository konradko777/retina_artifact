function electrode = findBestEleFromEI(EI)
    [~, electrode] = min(min(EI,[], 2));
    electrode = electrode - 1; %%because of first additional channel which is then ommited in chunked files
end