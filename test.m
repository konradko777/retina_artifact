positions = createHexagonalPositionMap(.37, .4, .13, .25, .20, .05);
positions2 = createHexagonalPositionMap(.50, .4, .13, .25, .20, .05);

for i = 1:size(positions,1)
    subplot('position', positions(i, :))
    subplot('position', positions2(i, :), 'yticklabel', '')
    
end