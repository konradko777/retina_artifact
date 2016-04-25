function plotPointsFittedAmpDesiredEff(transedEff, coeffs, desEff, currAmps)
    currAmpsDense = currAmps(1):.01:currAmps(end);
    estimatedAmp = sigmoidalInv(coeffs, desEff);
    xlim_ = xlim;
    
    hold on 
    grid on
    plot(currAmps, transedEff, 'g.', 'markersize', 20)
    plot(currAmpsDense, sigmoidalFunc(coeffs, currAmpsDense), 'linewidth', 2)
    plot(currAmps, transedEff, 'g.', 'markersize', 20)
    line([xlim_(1) estimatedAmp], [desEff desEff], 'color', 'r', 'linewidth', 3, 'linestyle', '--')
    line([estimatedAmp estimatedAmp], [0 desEff], 'color', 'r', 'linewidth', 3, 'linestyle', '--')
    ylim([-.01 1.01])
    xlabel('Stimulation current amplitude [\muA]', 'fontsize', 25)
    ylabel('Efficiency of stimulation [%]', 'fontsize', 25)
    set(gca, 'fontsize' ,20)
    set(gca, 'ytick', 0:.1:1)
    set(gca, 'yticklabels', get(gca, 'ytick') * 100)
    get(gca, 'yticklabels')
end