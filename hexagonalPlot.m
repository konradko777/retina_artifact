subplotWidth = 0.3;
subplotHeight = 0.3;
relativePos = {'-1  2'; ' 1  2';'-2  0';' 0  0';' 2  0';'-1 -2';' 1 -2'};
size(relativePos)
positions = {[0.2, 0.7, subplotWidth, subplotHeight]
             [0.55, 0.7, subplotWidth, subplotHeight]
             [0.03 0.35 subplotWidth, subplotHeight]
             [0.35 0.35 subplotWidth, subplotHeight]
             [0.67 0.35 subplotWidth, subplotHeight]
             [0.2, 0.03, subplotWidth, subplotHeight]
             [0.55, 0.03, subplotWidth, subplotHeight]
             };
relPosPlotPosMap = containers.Map(relativePos, positions);
figure

for i = 1:length(relativePos)
    relPos = relativePos{i};
    pos = relPosPlotPosMap(relPos);
    subplot('position', pos)
    plot(i, 'b.')
end

% figure
% subplot('position', [0.1 0.6 0.2 0.2])
% plot(x)
% subplot('position', [0.5 0.1 0.2 0.2])
% plot(x)

% przypisywanie z macierzy elektrod na macierz subplotow