function correctLegend2(legendHandle, color)
    children = get(legendHandle, 'children');
    children = flipud(children);
    set(children(5), 'color', 'b');
    set(children(8), 'color', color);
    set(children(8), 'LineStyle', '--');
end