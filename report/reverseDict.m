function newDict = reverseDict(dict)
    new_keys = [];
    new_vals = [];
    i = 0;
    for keyCell = keys(dict)
        i = i + 1;
        key = keyCell{1};
        val = dict(key);
        new_keys(i) = val;
        new_vals(i) = key;
    end
    newDict = containers.Map(new_keys, new_vals);
end