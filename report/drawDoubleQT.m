function drawDoubleQT(qt, color, OFFSET)
%     OFFSET = 17;
    FONTSIZE = 20;
    line(xlim, [qt qt], 'linewidth', 2, 'color', color)
    text(45, qt + OFFSET, 'QT', 'fontweight', 'bold', 'fontsize', FONTSIZE)
    line(xlim, [-qt -qt], 'linewidth', 2, 'color', color)
    text(45, -qt - OFFSET, 'QT', 'fontweight', 'bold', 'fontsize', FONTSIZE)

end