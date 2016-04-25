function plotEiSpike(eiSpikeTrace)
    plot(eiSpikeTrace, 'k', 'linewidth', 3)
    xlim([1, 50])
    set(gca, 'xtick', [1, 10, 20, 30, 40, 50])
    set(gca, 'xticklabels', [0, 10, 20, 30, 40, 50] * 50 / 1000)
    set(gca, 'Fontsize', 20)
    xlabel('t[ms]')
    ylabel('Napiecie')
end