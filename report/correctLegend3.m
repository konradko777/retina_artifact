function correctLegend3(legendHandle, n, color, linestyle)
    children = get(legendHandle, 'children');
    children = flipud(children);
    set(children(3*n - 1), 'LineStyle', linestyle, 'color', color);
%     set(children(2*n - 1), 'color', color);
end