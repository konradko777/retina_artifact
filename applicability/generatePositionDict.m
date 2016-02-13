function positions = generatePositionDict()
    %create POSITION dict
    ROWS = 4;
    COLUMNS = 6;
    positions = cell(ROWS * COLUMNS, 1);
    LEFT_MARIGIN = .02;
    BOTTOM_MARIGIN = .03;
    HEIGHT = .22;
    WIDTH = .15;
    SEPARATION = .015;
    i=1;
    for row = 1:ROWS
        for column = fliplr(1:COLUMNS)
            x = LEFT_MARIGIN + (column - 1) * (WIDTH + SEPARATION);
            y = BOTTOM_MARIGIN + (row - 1) * (HEIGHT + SEPARATION);
            positions{i} = [x y WIDTH HEIGHT];
            i = i + 1;
        end
    end
    positions = flipud(positions);

end