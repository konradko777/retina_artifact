function plotHexagonally3(adjacentEles, resultStructs, eiSpike, eiSpikeAmp,...
    spikeDetThres, stimEleFromThresFile, chosenElectrode)
    X_LIM = [0 50];
    OFFSET = 30;
    TITLE_FONTSIZE = 20;
    allSamplesRaw = getSamples(resultStructs, 'bestMovieTraces');
    allSamplesSbtr = getSamples(resultStructs, 'subtractedTraces');
    [yMinRaw, yMaxRaw] = getMinMax(allSamplesRaw);
    [yMinSbtr, yMaxSbtr] = getMinMax(allSamplesSbtr);
    [rawPosDict, sbtrctdPosDict] = createMappings(adjacentEles(1));
    movieFoundVec = cellfun(@(result) result.bestMovieIdx, resultStructs);
    i = 1;
    global DATA_PATH
    AMP_MOVIE_DICT = createAmpMovieMap(DATA_PATH);
    MOVIE_AMP_DICT =  reverseDict(AMP_MOVIE_DICT);    
    
    for movieFound = movieFoundVec
        currentElectrode = adjacentEles(i);
%         if ~resultStructs{i}.stableThresIdx
%             i = i + 1;
%             continue
%         end
        if movieFound > 0
            rawTraces = resultStructs{i}.bestMovieTraces;
            sbtrTraces = resultStructs{i}.subtractedTraces;
            spikesDetected = resultStructs{i}.spikesDetected;
            title_ = sprintf('                                Electrode: %d, Curr: %.2f\\muA, SF: %d', ...
                currentElectrode, MOVIE_AMP_DICT(movieFound*2 - 1), spikesDetected);
            [bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes] = ... 
                mingle4Sets(resultStructs{i}.firstStepArt, resultStructs{i}.firstStepSpikes, ...
                resultStructs{i}.secondStepArts, resultStructs{i}.secondStepSpikes);
            subplot('position', rawPosDict(currentElectrode))
                hold on
                plot4colors(rawTraces, bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes)
                xlim(X_LIM)
                ylim([yMinRaw - OFFSET, yMaxRaw + OFFSET])
                title(title_, 'fontsize', TITLE_FONTSIZE)
                set(gca, 'XLimMode', 'manual')
                set(gca, 'xtick', 0:10:40)
                set(gca, 'xticklabel', (get(gca, 'xtick') * 50 / 1000) )
                set(gca, 'fontsize', 20)
                if i ~= 1
                    set(gca, 'XTickLabel','')
                    set(gca, 'YTickLabel','')
                end
                if currentElectrode == stimEleFromThresFile
                    plotCircle(40, yMaxRaw - OFFSET, 'b')
                end
                if currentElectrode == chosenElectrode
                    plotCircle(35, yMaxRaw - OFFSET, 'g')
                end

                
            subplot('position', sbtrctdPosDict(adjacentEles(i)))
                hold on
                plot4colors(sbtrTraces, bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes)
                xlim(X_LIM)
                ylim([yMinSbtr - OFFSET, yMaxSbtr + OFFSET])
                plotSpikeAmpAndThres(spikeDetThres, spikeDetThres)
                plotEISpike(eiSpike)
                set(gca, 'XLimMode', 'manual')
                set(gca, 'xtick', 0:10:50)
                set(gca, 'xticklabel', (get(gca, 'xtick') * 50 / 1000) )
                set(gca, 'YAxisLocation', 'right')
                set(gca, 'fontsize', 20)
                if i ~= 1
                    set(gca, 'XTickLabel','')
                    set(gca, 'YTickLabel','')
                else
                    xlabh = xlabel('t[ms]', 'fontsize', 20);
                    ylim_ = ylim;
                    set(xlabh, 'position', [-1, ylim_(1) - abs(ylim_(1)*.2), 0]);
                end


        else
            subplot('position', rawPosDict(adjacentEles(i)))
            text(.5, .5, 'Application range', 'horizontalAlignment', 'center', 'fontsize', TITLE_FONTSIZE)
            set(gca, 'XTickLabel','')
            set(gca, 'YTickLabel','')
            if currentElectrode == stimEleFromThresFile
                plotCircle(.8, .8, 'b')
            end
            title(sprintf('                           Electrode: %d', currentElectrode), 'fontsize', TITLE_FONTSIZE)
            subplot('position', sbtrctdPosDict(adjacentEles(i)))
            text(.5, .5, 'not found', 'horizontalAlignment', 'center', 'fontsize', TITLE_FONTSIZE)
            set(gca, 'XTickLabel','')
            set(gca, 'YTickLabel','')
            
        end
        
        
        i = i + 1;
    end
%     relativePosPlotPosDict1 = createHexagonalPositionMap(.37, .4, .13, .25, .20, .05);
%     relativePosPlotPosDict2 = createHexagonalPositionMap(.50, .4, .13, .25, .20, .05);
    
end

function newDict = reverseDict(dict)
    new_keys = [];
    new_vals = [];
    i = 0;
    for keyCell = keys(dict)
        i = i + 1;
        key = keyCell{1};
        val = dict(key);
        new_keys(i) = val;
        new_vals(i) = key;
    end
    newDict = containers.Map(new_keys, new_vals);
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
    if res.bestMovieIdx > 0 && res.stableThresIdx
        value = getfield(res, fieldName);
    else
        value = [];
    end
end

function plotSpikeAmpAndThres(spikeAmp, detectionThres)
    line(xlim, [spikeAmp spikeAmp], 'color', 'b')
    line(xlim, [detectionThres detectionThres], 'color', 'k', 'linewidth', 2)
end

function plotEISpike(eiSpikeTrace)
    plot(eiSpikeTrace, '--b', 'linewidth', 2)
end

function [rawPosDict, sbtrctdPosDict] = createMappings(centralElectrode)
    global ELE_MAP_OBJ
    eleRelPosMap = createPositionDictForAdjEles(centralElectrode, ELE_MAP_OBJ);
    relPosPlotPosRawDict = createHexagonalPositionMap(.365, .36, .13, .25, .20, .09);
    relPosPlotPosSbtrDict = createHexagonalPositionMap(.505, .36, .13, .25, .20, .09);
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