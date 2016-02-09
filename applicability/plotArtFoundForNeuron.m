function plotArtFoundForNeuron(artFoundVec, movie, neuron, minMovie, maxMovie)
    plot(artFoundVec, '.-')
    ylim([0 50]);
    movie = movie - .3;
    line([movie movie], ylim, 'color', 'r')
    line([minMovie minMovie], ylim, 'color', 'g')
    line([maxMovie maxMovie], ylim, 'color', 'g')
    title(neuron)
%     ylabel('Artifacts found', 'fontsize', 14)
%     xlabel('Movie No.', 'fontsize', 14)
end