function plotOneMinusTwo(one, two, oneColor, twoColor, thres)
    one_minus_two = one - two;
    zeros_ = zeros(1,length(one));
    hold on
    grid on
    plot(one_minus_two, oneColor, 'linewidth', 3)
    plot(zeros_, twoColor, 'linewidth', 3)
    xlim([1 30])
    line(xlim, [thres thres], 'linewidth', 2, 'color', 'y')
    xlabel('Samples', 'fontsize', 30)
    set(gca, 'fontsize', 20)
end