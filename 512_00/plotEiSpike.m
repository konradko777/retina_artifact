function plotEiSpike(eiSpikeTrace)
    plot(eiSpikeTrace, 'k', 'linewidth', 3)
    xlim([1, 50])
    set(gca, 'Fontsize', 20)
    xlabel('Probki')
    ylabel('Napiecie')
    title('Obraz potencjalu czynnosciowego na elektrodzie', 'fontsize', 20)

end