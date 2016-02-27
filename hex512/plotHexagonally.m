function plotHexagonally(adjacentEles, resultStructs, eiSpike, eiSpikeAmp, spikeDetThres, stimEleFromThresFile)
    X_LIM = [0 50];
    OFFSET = 30;
    allSamplesRaw = getSamples(resultStructs, 'bestMovieTraces');
    allSamplesSbtr = getSamples(resultStructs, 'subtractedTraces');
    [yMinRaw, yMaxRaw] = getMinMax(allSamplesRaw);
    [yMinSbtr, yMaxSbtr] = getMinMax(allSamplesSbtr);
    [rawPosDict, sbtrctdPosDict] = createMappings(adjacentEles(1));
    movieFoundVec = cellfun(@(result) result.bestMovieIdx, resultStructs);
    i = 1;
    for movieFound = movieFoundVec
        currentElectrode = adjacentEles(i);
        if movieFound > 0
            rawTraces = resultStructs{i}.bestMovieTraces;
            sbtrTraces = resultStructs{i}.subtractedTraces;
            spikesDetected = resultStructs{i}.spikesDetected;
            title_ = sprintf('                                                 Electrode: %d, movieIdx: %d, SF: %d', currentElectrode, movieFound, spikesDetected);
            [bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes] = ... 
                mingle4Sets(resultStructs{i}.firstStepArt, resultStructs{i}.firstStepSpikes, ...
                resultStructs{i}.secondStepArts, resultStructs{i}.secondStepSpikes);
            subplot('position', rawPosDict(currentElectrode))
                hold on
                plot4colors(rawTraces, bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes)
                xlim(X_LIM)
                ylim([yMinRaw - OFFSET, yMaxRaw + OFFSET])
                title(title_)
                if i ~= 1
                    set(gca, 'XTickLabel','')
                    set(gca, 'YTickLabel','')
                end
                if currentElectrode == stimEleFromThresFile
                    plotCircle(40, yMaxRaw - OFFSET, 'b')
                end
            subplot('position', sbtrctdPosDict(adjacentEles(i)))
                hold on
                plot4colors(sbtrTraces, bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes)
                xlim(X_LIM)
                ylim([yMinSbtr - OFFSET, yMaxSbtr + OFFSET])
                plotSpikeAmpAndThres(eiSpikeAmp, spikeDetThres)
                plotEISpike(eiSpike)                
                set(gca, 'YAxisLocation', 'right')
                if i ~= 1
                    set(gca, 'XTickLabel','')
                    set(gca, 'YTickLabel','')
                end
        else
            subplot('position', rawPosDict(adjacentEles(i)))
            text(.5, .5, 'Application range', 'horizontalAlignment', 'center')
            set(gca, 'XTickLabel','')
            set(gca, 'YTickLabel','')
            title(sprintf('                                                Electrode: %d', currentElectrode))
            subplot('position', sbtrctdPosDict(adjacentEles(i)))
            text(.5, .5, 'not found', 'horizontalAlignment', 'center')
            set(gca, 'XTickLabel','')
            set(gca, 'YTickLabel','')
            
        end
        
        i = i + 1;
    end
%     relativePosPlotPosDict1 = createHexagonalPositionMap(.37, .4, .13, .25, .20, .05);
%     relativePosPlotPosDict2 = createHexagonalPositionMap(.50, .4, .13, .25, .20, .05);
    
end

function plotCircle(x, y, color)
    plot(x, y, '.', 'color', color, 'MarkerSize', 25);
end

function [min_, max_] = getMinMax(vec)
    min_ = min(vec);
    max_ = max(vec);

end

function samples = getSamples(resCell, fieldName)
    extracted = cellfun(@(res) extractFieldName(res, fieldName), resCell, 'UniformOutput', false);
    empty = cellfun(@isempty, extracted);
    samples = cell2mat(extracted(1, ~empty));
    samples = samples(:);

end

function value = extractFieldName(res, fieldName)
    if res.bestMovieIdx > 0
        value = getfield(res, fieldName);
    else
        value = [];
    end
end

function plotSpikeAmpAndThres(spikeAmp, detectionThres)
    line(xlim, [spikeAmp spikeAmp], 'color', 'b')
    line(xlim, [detectionThres detectionThres], 'color', 'k')
end

function plotEISpike(eiSpikeTrace)
    plot(eiSpikeTrace, '--b', 'linewidth', 2)
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
        electrode = electrodeCell{1}
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