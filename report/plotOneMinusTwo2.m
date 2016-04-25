function plotOneMinusTwo2(one, two, oneColor, twoColor, thres, ylim_, xlim_)
    one_minus_two = one - two;
    zeros_ = zeros(1,length(one));
    hold on
    grid on
    plot(one_minus_two, oneColor, 'linewidth', 3)
    plot(zeros_, twoColor, 'linewidth', 3)
    xlim(xlim_)
    ylim(ylim_)
    if thres
        line(xlim, [thres thres], 'linewidth', 2, 'color', 'y')
        text(27, thres + 2, 'QT', 'fontweight', 'bold', 'fontsize', 30)
    end
%     xlabel('Samples', 'fontsize', 30)
%     set(gca, 'fontsize', 20)
end