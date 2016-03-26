function positions = generatePositionDict2(ROWS, COLUMNS)
    %create POSITION dict
    positions = cell(ROWS * COLUMNS, 1);
    LEFT_MARIGIN = .04;
    RIGHT_MARIGIN = .02;
    BOTTOM_MARIGIN = .06;
    TOP_MARIGIN = .03;
    HORIZONTAL_SEPARATION = .015;
    VERTICAL_SEPARATION = .015;
    HEIGHT = (1 - TOP_MARIGIN - BOTTOM_MARIGIN - VERTICAL_SEPARATION * (ROWS - 1)) / ROWS;
    WIDTH = (1 - LEFT_MARIGIN - RIGHT_MARIGIN - HORIZONTAL_SEPARATION * (COLUMNS - 1)) / COLUMNS;
    i=1;
    for row = 1:ROWS
        for column = fliplr(1:COLUMNS)
            x = LEFT_MARIGIN + (column - 1) * (WIDTH + HORIZONTAL_SEPARATION);
            y = BOTTOM_MARIGIN + (row - 1) * (HEIGHT + VERTICAL_SEPARATION);
            positions{i} = [x y WIDTH HEIGHT];
            i = i + 1;
        end
    end
    positions = flipud(positions);

end