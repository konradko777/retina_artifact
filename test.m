function value = test(resCell, fieldName)
    extracted = cellfun(@(res) extractFieldName(res, fieldName), resCell, 'UniformOutput', false);
    empty = cellfun(@isempty, extracted);
    value = extracted(1, ~empty);
end

function samples = getSamples(resCell, fieldName)
    extracted = cellfun(@(res) extractFieldName(res, fieldName), resCell, 'UniformOutput', false);
    empty = cellfun(@isempty, extracted);
    samples = cell2mat(extracted(1, ~empty));
    samples = samples(:);

end

function value = extractFieldName(res, fieldName)
    if res.bestMovieIdx > 0
        value = getfield(res, fieldName);
    else
        value = [];
    end
end