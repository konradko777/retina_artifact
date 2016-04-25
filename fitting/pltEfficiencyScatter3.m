function plotEfficiencyScatter3(x_data, y_data, xlim_)
    global DATA_PATH
    ampMovieDict = createAmpMovieMap(DATA_PATH);
    movieAmpDict = reverseDict(ampMovieDict);
    occMat = generateOccuranceMat(x_data, y_data);
    xoffset = .1;
    yoffset = .6;
    hold on
    for i = 1:length(x_data)
        x = x_data(i);
        y = y_data(i);
        if all([x, y] > 0)
            plot(x, y, 'b.', 'MarkerSize', 20)
            text(x + xoffset, y + yoffset, num2str(occMat(x, y)), 'fontsize', 15)
        end
    end
    xlims = xlim_;
    ylims = [2 32];
    plot([xlims(1): xlims(2)], [xlims(1): xlims(2)], 'r', 'linewidth', 2)
    for i = 1:length(x_data)
        x = x_data(i);
        y = y_data(i);
        if all([x, y] > 0)
            plot(x, y, 'b.', 'MarkerSize', 20)
            text(x + xoffset, y + yoffset, num2str(occMat(x, y)), 'fontsize', 15)
        end
    end
    grid on
%     axis equal
    set(gca, 'xtick', xlims(1):xlims(2))
    set(gca, 'ytick', ylims(1):ylims(2))
    ylim([2, 33])
    xlim(xlim_)
    xlabel('Amplitude chosen by algorithm [\muA]', 'fontsize', 20)
    ylabel('Amplitude chosen manually [\muA]', 'fontsize', 20)
    set(gca, 'xticklabels', sprintf('%.2f|', createTickLabels((xlims(1):xlims(2))* 2 - 1, movieAmpDict)))
    set(gca, 'yticklabels', sprintf('%.2f|', createTickLabels((ylims(1):ylims(2))* 2 - 1, movieAmpDict)))
    set(gca, 'fontsize', 15)
end

function labels = createTickLabels(indices, dict_)
    labels = zeros(size(indices));
    for i = 1:length(indices)
        labels(i) = dict_(indices(i));
    end

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