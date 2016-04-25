addJava
setGlobals512_00
load 512_00_all_vars

%%
NEURON_ID = 755;
movie = 59;
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);

%%
gray = [.3 .3 .3];
plot(traces', 'color', gray, 'linewidth', 2)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)

%%
cmap = jet(50);
hold on
for i = 1:50
    plot(traces(i, :), 'color', cmap(i, :), 'linewidth', 2)
end
colormap(cmap)
xticks = [1 5:5:50];%0:5:50;
ticklabels = cellfun(@createThLabel, num2cell(xticks, 1), 'UniformOutput', false);
colorbar('ytick', xticks, 'yticklabels', ticklabels)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)


%%
NEURON_ID = 938;
movie = 61;
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
%%
cmap = jet(50);
hold on
for i = 1:50
    plot(traces(i, :), 'color', cmap(i, :), 'linewidth', 2)
end
colormap(cmap)
xticks = [1 5:5:50];%0:5:50;
ticklabels = cellfun(@createThLabel, num2cell(xticks, 1), 'UniformOutput', false);
colorbar('ytick', xticks, 'yticklabels', ticklabels)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)
%%
addJava
setGlobals512
load stimEleFoundFixed

NEURON_ID = 889;
movie = 63;
recEle = NEURON_REC_ELE_MAP(NEURON_ID);
pattern = NEURON_ELE_MAP(NEURON_ID);
traces = getMovieElePatternTraces(movie, recEle, pattern);
%%
cmap = jet(50);
hold on
for i = 1:50
    plot(traces(i, :), 'color', cmap(i, :), 'linewidth', 2)
end
colormap(cmap)
xticks = [1 5:5:50];%0:5:50;
ticklabels = cellfun(@createThLabel, num2cell(xticks, 1), 'UniformOutput', false);
colorbar('ytick', xticks, 'yticklabels', ticklabels)
set(gca, 'xticklabel', get(gca, 'xtick') *50 / 1000)
set(gca, 'fontsize', 20)
xlabel('t[ms]', 'fontsize', 25)

%1set 1 wystapienie; 
%2. 20 wyst., 
%3. 0 wyst





