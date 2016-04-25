function merged = mergeMatrices(mat1, mat2)
    %assumes that both matrices consists the same keys (first  columns)
    [idxa, idxb] = ismember(mat1(:, 1), mat2(:, 1));
    merged = [mat1(idxa, :), mat2(idxb, 2:end)];

end