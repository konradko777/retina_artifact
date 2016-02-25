function positionDict = createHexagonalPositionMap(x, y, width, height, hsep, vsep)
%     labels = {'central', 'northwest'}
%     for row = [1 -1]
%         for col = [-1 1]
    relativePos = {'-1  2'; '1  2';'-2  0';'0  0';'2  0';'-1 -2';'1 -2'};
    positions = [x - width - hsep/3, y + height + vsep, width, height;
                 x + width + hsep/3, y + height + vsep, width, height;
                 x - width - hsep, y, width, height;
                 x, y, width, height;
                 x + width + hsep, y, width, height;
                 x - width - hsep/3, y - height - vsep, width, height;
                 x + width + hsep/3, y - height - vsep, width, height];
            
    positionDict = containers.Map();
    for i = 1:length(relativePos)
        positionDict(relativePos{i}) = positions(i,:);
    end
      
end