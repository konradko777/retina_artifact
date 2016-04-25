function plotScatterWithTextLabels(numericalLabels, xvalues, yvalues, amplitudes, FONTSIZE)
    textlabels = cellfun(@num2str, num2cell(numericalLabels), 'UniformOutput', false);
    hold on
    plot(xvalues, yvalues, 'b.')
    plot(amplitudes, amplitudes, 'r')
    for i = 1:size(textlabels)
        text(xvalues(i), yvalues(i), textlabels(i), 'fontsize', FONTSIZE);        
    end
    
end