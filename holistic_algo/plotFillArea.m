function plotFillArea(trace1, trace2)

    subplot(2,1,1)
    plot([trace1' trace2'])
    title('Sample mean artifact traces')
    subplot(2,1,2)
    
    x=1:length(trace1);                  %#initialize x array
    
    X=[x,fliplr(x)];                %#create continuous x value array for plotting
    Y=[trace1,fliplr(trace2)];              %#create y values for out and then back
    fill(X,Y,'b');   
    title('Measure of dissimilarity - area between curves')
end