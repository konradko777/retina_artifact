classdef ManualThresholdServer < SpikeDetThresholdServer
    properties
        thresDict
    end
    methods
        function serverObj = ManualThresholdServer(SEREMovieMat, movies)
            if size(SEREMovieMat,2) == 3
                SEREMovieMat = serverObj.addEntryForeveryMovie(SEREMovieMat, movies); %%% doko?czy?
            elseif ~any(size(SEREMovieMat,2) == [3, 4])
                error('Columns: stimulation electrode, recording electrode, (optionally movie) and spike detection threshold must be included')
            end
            serverObj.thresDict = serverObj.createDictFromSEREMat(SEREMovieMat);
        end
        function dict_ = createDictFromSEREMat(serverObj, SEREMat)
            keys_ = arrayfun(@serverObj.makeCharKey, SEREMat(:, 1),...
                SEREMat(:, 2), SEREMat(:, 3), 'UniformOutput', false);
            dict_ = containers.Map(keys_, SEREMat(:, 4)); 
            
        end    
        function charKey = makeCharKey(serverObj, se, re, movie)
            charKey = sprintf('%d %d %d', se, re, movie);            
        end
        function filledInMatrix = addEntryForeveryMovie(serverObj, SEREMovieMat, movies)
            filledInMatrix = zeros(0, 4);
            nMovies = length(movies);
            movies = ensureColumnVec(movies);
            for i = 1:size(SEREMovieMat, 1)
                row = SEREMovieMat(i, :);
                replicatedRow = repmat(row, nMovies, 1);
                filledInMatrix = [filledInMatrix; [replicatedRow(:, [1 2]) movies replicatedRow(:, 3)]];
            end
            function columnVec = ensureColumnVec(vec)
                if size(vec, 2) > size(vec,1)
                    columnVec = vec';
                else
                    columnVec = vec;
                end
                
            end

        end
        function threshold = giveThresholdForElectrodesMovie(serverObj, stimEle, recEle, movie)
            threshold = serverObj.thresDict(serverObj.makeCharKey(stimEle, recEle, movie);           
        end
    end
end
