function correctLegendScatter(lh)
    children = flipud(get(lh, 'children'));
    set(children(3), 'markersize', 10)
    set(children(6), 'markersize', 20)
    set(children(9), 'markersize', 30)
    set(children(12), 'markersize', 40)
    set(children(15), 'markersize', 10, 'color', 'b')



end