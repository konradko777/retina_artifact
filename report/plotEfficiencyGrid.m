function plotEfficiencyGrid(neurons, efficiencyDict)
    global NEURON_IDS
    grid_ = ones(length(neurons), 32);
    colors = ['b', 'g', 'm'];
    i = 0;
    for neuron = neurons
        i = i + 1;
        movieIdxVec = efficiencyDict(neuron);
        for j = 1:3
            movieIdx = movieIdxVec(j);
            if movieIdx > 0
                grid_(i, movieIdx) = j + 1;
            end            
        end
        if movieIdxVec(2) == movieIdxVec(3) 
            grid_(i, movieIdxVec(2)) = 5;
        end
    end
    imagesc(grid_)
    colormap([1 1 1; 0 0 1; 0 1 0; 1 0 1; 0 1 1;])
    axis equal
    x = (1:32) +.5;
    y = (1:70) +.5;
    set(gca, 'xtick', x)
    set(gca, 'xticklabel', 1:32)
    set(gca, 'ytick', y)
    set(gca, 'yticklabel', NEURON_IDS)
    grid on
    set(gca, 'GridLineStyle', '-')
    ylim([.5 70.5])
    xlim([.5 32.5])

end