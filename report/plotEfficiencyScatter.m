function plotEfficiencyScatter(x_data, y_data)
    occMat = generateOccuranceMat(x_data, y_data);
    xoffset = .1;
    yoffset = .4;
    hold on
    for i = 1:length(x_data)
        x = x_data(i);
        y = y_data(i);
        if all([x, y] > 0)
            plot(x, y, 'b.', 'MarkerSize', 20)
            text(x + xoffset, y + yoffset, num2str(occMat(x, y)))
        end
    end
    xlims = xlim;
    plot([xlims(1): xlims(2)], [xlims(1): xlims(2)], 'r')
    grid on
end


function occMat = generateOccuranceMat(x_data, y_data)
    max_x = max(x_data);
    max_y = max(y_data);
    occMat = zeros(max_x, max_y);
    for i = 1:length(x_data)
        x = x_data(i);
        y = y_data(i);
        if all([x, y] > 0)
            occMat(x, y) = occMat(x, y) + 1;
        end
    end
end