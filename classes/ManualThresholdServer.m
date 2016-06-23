classdef ManualThresholdServer < SpikeDetThresholdServer
% Returns information about threshold used in spike detection step.
% Information has to be manually uploaded by user.
    properties
        thresDict
    end
    methods
        function serverObj = ManualThresholdServer(SEREMovieMat, movies)
        % A constructor returning ManualThresholdServer object when
        % provided with information about electrodes, movies, and spike
        % detection thresholds. Field serverObj.thresDict is initialized by
        % the constructro.
        % Input:
        %     SEREMovieMat(Array<Float>): a matrix that contains all
        %         necessary information. Columns of the matrix holds
        %         following information:
        %         1st. stimulation electrode ID
        %         2nd. recording electrode ID
        %         3rd. amplitude integer representation
        %         4th. spike detection threshold
        %         If detection threshold is the same for every amplitude
        %         regarding SE-RE pair, third column may be ommited, and
        %         the information will be automatically filled.
        %     movies(Vector<Int>): integer representation of stimulation
        %         amplitudes used during experiment
            if size(SEREMovieMat,2) == 3
                SEREMovieMat = serverObj.addEntryForeveryMovie(SEREMovieMat, movies);
            elseif ~any(size(SEREMovieMat,2) == [3, 4])
                error('Columns: stimulation electrode, recording electrode, (optionally movie) and spike detection threshold must be included')
            end
            serverObj.thresDict = serverObj.createDictFromSEREMat(SEREMovieMat);
        end
        function dict_ = createDictFromSEREMat(serverObj, SEREMat)
        % Extracts information from SEREmat and transfers it to dict_
        % variable.
        % Input:
        %     SEREMovieMat(Array<Float>): a matrix that contains all
        %         necessary information. Columns of the matrix holds
        %         following information:
        %         1st. stimulation electrode ID
        %         2nd. recording electrode ID
        %         3rd. amplitude integer representation
        %         4th. spike detection threshold
        % Output:
        %     dict_(containers.Map): dictionary where keys are string
        %         representation of stiulation electrode, recording
        %         electrode and integer stimulation amplitude 
        %         representation while values being spike detection
        %         thresholds.
            keys_ = arrayfun(@serverObj.makeCharKey, SEREMat(:, 1),...
                SEREMat(:, 2), SEREMat(:, 3), 'UniformOutput', false);
            dict_ = containers.Map(keys_, SEREMat(:, 4)); 
            
        end    
        function charKey = makeCharKey(serverObj, se, re, movie)
        % Changes numericals to string form.
        % Input:
        %     se(Int): stimulation electrode ID.
        %     re(Int): recording electrode ID.
        %     movie(Int): amplitude integer representation
        % Output:
        %     charKey(String): string creted with electrodes and movie
        %         information
            charKey = sprintf('%d %d %d', se, re, movie);            
        end
        function filledInMatrix = addEntryForeveryMovie(serverObj, SEREMovieMat, movies)
        % If spike detection threshold is constant throughout all
        % amplitudes a lot of redundancy would be introduced to
        % SEREMovieMat. It suffice to use 3 columns instead of 4 and by
        % using this method the 4th one(concerning stimulation amplitudes)
        % will be added.
        % Input:
        %     SEREMovieMat(Array<Float>): a matrix that contains 
        %         information about stimulation electrode, recording 
        %         electrode and spike detectio threshold. It does not 
        %         include info about movie(integer amp representation).
        %         It is assumed that spike detection threshold is constant
        %         throughout all amplitudes. Columns of the matrix holds
        %         following information:
        %         1st. stimulation electrode ID
        %         2nd. recording electrode ID
        %         3rd. spike detection threshold
        %     movies(Vector<Int>): integer representation of stimulation
        %         amplitudes used during experiment
        % Output:
        %     SEREMovieMat(Array<Float>): a matrix with another column
        %         added considering integer representation of stimulation 
        %         amplitudes. Resultant array cas columns as follows:
        %         1st. stimulation electrode ID
        %         2nd. recording electrode ID
        %         3rd. amplitude integer representation
        %         4th. spike detection threshold
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
        % A method that is used to convey informatio about what detection
        % threshold should by use by spikeDetector object.
        % Input:
        %     stimEle(Int): stimulation electrode ID
        %     recEle(Int): recording electrode ID
        %     movie(Int): amplitude integer representation
        % Output:
        %     threshold(Float): spike detection threshold.
            threshold = serverObj.thresDict(serverObj.makeCharKey(stimEle, recEle, movie);           
        end
    end
end
