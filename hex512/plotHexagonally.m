function plotHexagonally(adjacentEles, resultStructs)
    X_LIM = [0 50];
    [rawPosDict, sbtrctdPosDict] = createMappings(adjacentEles(1));
    movieFoundVec = cellfun(@(result) result.bestMovieIdx, resultStructs);
    i = 1;
    for movieFound = movieFoundVec
        
        if movieFound > 0
            subplot('position', rawPosDict(adjacentEles(i)))
                hold on
                plotSelectedTraces(resultStructs{i}.bestMovieTraces, resultStructs{i}.secondStepSpikes, 'g')
                plotSelectedTraces(resultStructs{i}.bestMovieTraces, resultStructs{i}.firstStepArt, 'r')
                xlim(X_LIM)
            subplot('position', sbtrctdPosDict(adjacentEles(i)))
                hold on
                plotSelectedTraces(resultStructs{i}.subtractedTraces, resultStructs{i}.secondStepSpikes, 'g')
                plotSelectedTraces(resultStructs{i}.subtractedTraces, resultStructs{i}.firstStepArt, 'r')
                xlim(X_LIM)
                set(gca, 'YAxisLocation', 'right')
        else
            subplot('position', rawPosDict(adjacentEles(i)))
            text(.5, .5, 'Application range', 'horizontalAlignment', 'right')
            subplot('position', sbtrctdPosDict(adjacentEles(i)))
            text(.5, .5, 'not found', 'horizontalAlignment', 'left')
        end
        
        i = i + 1;
    end
%     relativePosPlotPosDict1 = createHexagonalPositionMap(.37, .4, .13, .25, .20, .05);
%     relativePosPlotPosDict2 = createHexagonalPositionMap(.50, .4, .13, .25, .20, .05);
    
end

function [rawPosDict, sbtrctdPosDict] = createMappings(centralElectrode)
    global ELE_MAP_OBJ
    eleRelPosMap = createPositionDictForAdjEles(centralElectrode, ELE_MAP_OBJ);
    relPosPlotPosRawDict = createHexagonalPositionMap(.37, .4, .13, .25, .20, .05);
    relPosPlotPosSbtrDict = createHexagonalPositionMap(.50, .4, .13, .25, .20, .05);
    electrodeKeys = values(eleRelPosMap);
    rawPosDict = containers.Map('keytype', 'int32', 'valuetype', 'any');
    sbtrctdPosDict = containers.Map('keytype', 'int32', 'valuetype', 'any');
    for electrodeCell = keys(eleRelPosMap)
        electrode = electrodeCell{1};
        rawPosDict(electrode) = relPosPlotPosRawDict(eleRelPosMap(electrode));
        sbtrctdPosDict(electrode) = relPosPlotPosSbtrDict(eleRelPosMap(electrode));
    end
end
% 
% function prunedDict = pruneDictToExistingKeys(keys_, dictToPrune)
%     prunedDict = containers.Map('KeyType', 'char', 'ValueType', 'any');
%     for i = 1:length(keys_)
%         key = keys_{i};
%         prunedDict(key) = dictToPrune(key);
%     end
% 
% end