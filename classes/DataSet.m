classdef DataSet < handle
    % A main object, where path to sliced datafiles is stored, allowing user
    % to perform actions like estimating of stimulation artifacts, spike
    % sorting, selecting optimal stimulation current or best stimulation
    % electrode for different Stimulation Electrode - Recording Electrode pairs.
    properties
        tracesNumberLimit;
        eventNumber = 0;
        electrodeLayoutObj;
        samplingRate
        applicationRange = [10 48]; %opisac, sprawdzic na co to wplywa (na pewno fitting i interpretationVector)
        dataPath
        movies
        currentAmps
        artClassifierObj
        spikeDetectorObj
        artClassifierObject
        spikeDetectionMethod
        thresholdServerObj
        interpreterObj
        stimAmpSelectorObj
        elecRespStruct
    end
    
    methods
        %% DataSet constructor
        function dataSetObj = DataSet(dataPath, visionPath, elecRespStruct, ...
                nElectrodes, spikeDetectionMethod, applicationRange)
        % A DataSet object constructor.
        % Input:
        %     dataPath(String): a path to location where files with sliced
        %         data (each file regarding different stimulation pattern
        %         and current amplitude) are stored.
        %     visionPath(String): path to Vision java library.
        %     tracesNumberLimit(Int): number of repetition of stimulus on one
        %         electrode for given current
        %     nElectrodes(Int): numbe of electrodes used in experimental
        %         setup
        %     samplingRate(Float): a sampling rate with which data was
        %         collected in Hz
        %     spikeDetectionMethod(String): currently when equals to
        %         'largestQT' it passes information about largest QT in
        %         stability island to SpikeDetectionThresholdServer object.
        %         Apart from that its values is arbitrary
        %     movies(Vector(Int)): integers that are used to describe
        %         consecutive stimulation amplitudes in names of files in
        %         location specified by dataPath parameter.
            javaaddpath(visionPath);
            dataSetObj.dataPath = dataPath;
            dataSetObj.spikeDetectionMethod = spikeDetectionMethod;
            dataSetObj.elecRespStruct = elecRespStruct;
            dataSetObj.movies = elecRespStruct.stimInfo.movieNos;
            dataSetObj.currentAmps = elecRespStruct.stimInfo.stimAmps;
            dataSetObj.applicationRange = applicationRange;
%             dataSetObj.tracesNumberLimit = tracesNumberLimit;
            dataSetObj.electrodeLayoutObj = ...
                edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(nElectrodes);
            dataSetObj.samplingRate = dataSetObj.elecRespStruct.details.sample_rate;
        end 
        %% attaching other objects to DataSet object
        function attachThresServerObj(dataSetObj, thresServObj)
        % Attaches spikeDetectionThresholdServer object which is
        % responsible for providing value used in spike detection step
        % Input:
        %     thresServObj(SpikeDetThresholdServer): object being instance
        %         of a class realising abstract SpikeDetThresholdServer
        %         class
            dataSetObj.thresholdServerObj = thresServObj;            
        end
        function attachArtClassifierObj(dataSetObj, artClassObj)
        % Attaches artClassifier object which is used in stimulation
        % artifact estimation setp
        % Input:
        %     artClassObj(QTArtClassifier): object of QTArtClassifier class
            dataSetObj.artClassifierObject = artClassObj;            
        end
        function attachSpikeDetectorObj(dataSetObj, spikeDetectorObj)
        % Attaches object used to determine whether given trace
        % should be classified as spike
        % Input:
        %     spikeDetectorObj(AbstractSpikeDetector): instance of a class being 
        %         realisation of AbstractSpikeDetector class
            dataSetObj.spikeDetectorObj = spikeDetectorObj;
        end
        function attachInerpreterObj(dataSetObj, inerpreterObj)
        % Attaches object which tells whether estimated stimulation
        % artifact trully doesn't contain any neural activity.
        % Input:
        %     intepreterObj(ResultInterpreter): instance of a
        %         ReusultInterpreter class
            dataSetObj.interpreterObj = inerpreterObj;            
        end
        function attachStimAmpSelectorObj(dataSetObj, stimAmpSelectorObj)
        % Attaches object responsible for selecting optimal stimulation electrode.
        % Input:
        %     stimAmpSelectorObj(StimAmpSelector): instance of a
        %         StimAmpSelector class
            dataSetObj.stimAmpSelectorObj = stimAmpSelectorObj;            
        end
        %% reading data
        function traces = getTracesForPatternMovieEle(dataSetObj, pattern, movie, ele)
        % Method used to read sliced data saved in binary files for one
        % pair of stimulation electrode/pattern and recording electrode (ele)
        % for given movie.
        % Input:
        %     pattern(Int): integer representation of pattern of
        %         electrode(s) used to stimulate retina.
        %     movie(Int): integer representation of current amplitude used
        %         to stimulate retina.
        %     ele(Int): integer representation of electrode from which the
        %         voltage was recorded.
        % Output:
        %     traces(Array<Float>): each row of that matrix is representing
        %         registered voltage after electric stimulus. The number of
        %         rows is equal to dataSetObj.tracesNumberLimit.
            movieID = find(dataSetObj.elecRespStruct.stimInfo.artMovieNos == movie);
            tracesNumberLimit = dataSetObj.elecRespStruct.stimInfo.nPulses(movieID);
            [allEleTraces,~,~] = NS_ReadPreprocessedData( ...
                dataSetObj.dataPath, dataSetObj.dataPath,0, pattern, movie, ...
                tracesNumberLimit, dataSetObj.eventNumber);
            traces = squeeze(allEleTraces(:, ele, :));
        end
        function allTracesCell = getAllTracesForSEREpair(dataSetObj, stimEle, ele, movies)
        % Method used to read sliced data saved in binary files for one
        % pair of stimulation electrode/pattern and recording electrode (ele)
        % for given movies.
        % Input:
        %     stimEle(Int): integer representation of
        %         electrode used to stimulate retina.
        %     movies(Vector<Int>): integer representation of current amplitudes
        %         used to stimulate retina.
        %     ele(Int): integer representation of electrode from which the
        %         voltage was recorded.
        % Output:
        %     allTracesCell(CellVector<Array<Float>>): each Cell contains a
        %         matrix with traces registered after every repetition of
        %         given amplitude.
            allTracesCell = cell(size(movies));
            for i = 1:length(movies)
                movie = movies(i);
                allTracesCell{i} = dataSetObj.getTracesForPatternMovieEle(stimEle, movie, ele);
            end
        end
        %% estimating stimulation artifacts

        function meanArt = getMeanArtForMovie(dataSetObj, traces, pattern, movie, ele)
        % Returns stimulation artifact estimate for given
        % pattern(stimulation electrode ID), amplitude ID (movie) and
        % recording electrode (ele). Uses dataSetObj.artClassifierObject
        % field. Information for electrodes and amplitude
        % is only used to pass information about Quantization Threshold
        % used.
        % Input:
        %     traces(Array<Float>): each row of that matrix is representing
        %         registered voltage after electric stimulus. The number of
        %         rows is equal to dataSetObj.tracesNumberLimit.
        %     pattern(Int): integer representation of pattern of
        %         electrode(s) used to stimulate retina.
        %     movie(Int): integer representation of current amplitude used
        %         to stimulate retina.
        %     ele(Int): integer representation of electrode from which the
        %         voltage was recorded.
        % Output:
        %     meanArt(Vector<Float>): a stimulation artifact estimate.
            [artIDs, largestQT] = dataSetObj.artClassifierObject.getArtIDsAndLargestQT(traces);
            if isempty(artIDs)
                meanArt = zeros(1, size(traces, 2));
                disp('Stability island not found. Unable to estimate stimulation artifact');
            elseif length(artIDs) == 1
                meanArt = traces(artIDs, :);
            else
                meanArt = mean(traces(artIDs, :));
            end
            if strcmp(dataSetObj.spikeDetectionMethod, 'largestQT')
                dataSetObj.thresholdServerObj.saveThresForElectrodesMovie(pattern, ele, movie, largestQT);
            end
        end
        function meanArtsMat = getMeanArtsForMovies(dataSetObj, allTracesCellMat, pattern, ele, movies)
        % Method that estimates stimulation artifact for each movie ID
        % specified in movies.
        % Input:
        %     allTracesCellMat(CellVector<Array<<Float>>): a cell matrix that in each cell
        %         contains all traces registered with given stimulation
        %         amplitude. Reuturned by getAllTracesForSEREpair method.
        %     pattern(Int): integer representation of pattern of
        %         electrode(s) used to stimulate retina.
        %     movies(Vector<Int>): integer representation of current amplitudes
        %         used to stimulate retina.
        %     ele(Int): integer representation of electrode from which the
        %         voltage was recorded.
        % Output:
        %     meanArtsMat(Array<Float>): each row of the array represents
        %         stimulation artifact for consecutive amplitude whose ID
        %         is spiecified in movies vector.
            nMovies = length(movies);
            meanArtsMat = cell(nMovies, 1);
            for i = 1:nMovies
                movie = movies(i);
                traces = allTracesCellMat{i};
                meanArtsMat{i} = getMeanArtForMovie(dataSetObj, traces, pattern, movie, ele);
            end
            
            meanArtsMat = cell2mat(meanArtsMat);
        end
        % Spike Detection methods
        function spikesDetectedMat = detectSpikesForMovie(dataSetObj, ...
                traces, artifact, threshold, movie)
        % Method that performs spike detection using dataSetObj.spikeDetectorObj
        % field when provided with artifact model and spike detection
        % threshold.
        % Input:
        %     traces(Array<Float>): each row of that matrix is representing
        %         registered voltage after electric stimulus. The number of
        %         rows is equal to dataSetObj.tracesNumberLimit.
        %     artifact(Vector<Float>): a stimulation artifact estimation
        %     threshold(Float): spike detection threshold passed to
        %          dataSetObj.spikeDetectorObj object.
        %     movie(Int): integer representation of stimulation amplitude.
        % Output:
        %     spikesDetectedMat(Array<Float>): a matrix that summarizes all
        %         spikes found for given amplitude. Each row represents one
        %         spike and columns are as follows: 
        %             1) movie(Int): ID of stimulation amplitude,
        %             2) repetition(Int):  i, if spike occured as response
        %                 to ith stimulus, 
        %             3) sample(Float): interpolated index of a sample when
        %                 voltage reached half amplitude of a spike.
        nTraces = size(traces,1);
            spikesDetectedMat = zeros(0,3);
            j = 0;
            for i = 1:nTraces
                [spikeDet, halfMaxIdx] = dataSetObj.spikeDetectorObj.detectSpike(...
                    traces(i, :), artifact, threshold);
                if spikeDet
                    j = j + 1;
                    spikesDetectedMat(j,:) = [movie, i, halfMaxIdx];
                end
            end
        end
        function allSpikesDetectedMat = detectSpikesForAllMovies(dataSetObj, allTracesCell, meanArtifactsMat, pattern, recEle, movies)
        % Performs spike detection for each movie specified in movies
        % provided with traces registered during stimulation and artifacts
        % estimation for that movies. Pattern(stimulation electrode) and
        % recording electrode(recEle) are needed to retrieve spike detection
        % threshold.
        % Input:
        %     allTracesCell(CellVector<Array<<Float>>): a cell matrix 
        %         that in each cell contains all traces registered with 
        %         given stimulation amplitude. 
        %     meanArtifactsMat(Array<Float>): each row represents
        %         stimulation artifact estimation for given amplitude
        %     pattern(Int): integer representation of pattern of
        %         electrode(s) used to stimulate retina.
        %     recEle(Int): integer representation of electrode from which the
        %         voltage was recorded.
        %     movies(Vector<Int>): integer representation of current amplitudes
        %         used to stimulate retina.
        % Output:
        %     allSpikesDetectedMat(Array<Float>): a matrix where each row
        %         represents detected spike with columns as follows:
        %             1) movie(Int): ID of stimulation amplitude,
        %             2) repetition(Int):  i, if spike occured as response
        %                 to ith stimulus, 
        %             3) sample(Float): interpolated index of a sample when
        %                 voltage reached half amplitude of a spike.
            allSpikesDetectedMat = zeros(0, 3);
            for i = 1:length(movies)
                traces = allTracesCell{i};
                meanArt = meanArtifactsMat(i,:);
                movie = movies(i);
                spikeDetectionThres = dataSetObj.thresholdServerObj.giveThresholdForElectrodesMovie(pattern, recEle, movie);
                detectedSpikes = dataSetObj.detectSpikesForMovie(traces, meanArt, spikeDetectionThres, i);
                allSpikesDetectedMat = [allSpikesDetectedMat; detectedSpikes];
            end
        end

        % Interpretation step methods
        function interpretationVector = interpretResults(dataSetObj, spikeDetectedVec)
        % Uses dataSetObj.interpreterObj field to return binary
        % interpretationVector stating where the algorithm estimated true
        % stimulation artifact (ones in resulting vector) and which
        % amplitudes resulting in full efficiency stimulation causing
        % algorithm estimation to be linear combination of the artifact and
        % neuron spike (zeros in returned vector)
        %     Input:
        %         spikeDetectedVec(Vector<Int>): vector where each number
        %            represents how many spikes were detected for consecutive
        %            stimulation current amplitude.
        %     Output:
        %         interpretationVector(Vector<Boolean>): ones in this
        %              vectors represents proper artifact estimate, while
        %              zeros suggests estimate of artifact plus spike.
        interpretationVector = dataSetObj.interpreterObj.giveInterpretationVec(spikeDetectedVec);            
        end
        %% main method
        function [interpretationVec, artifactEstimations, spikeMatrix] = ...
                analyzeSEREpair(dataSetObj, stimEle, recEle)
        % Main DataSet class function allowing full analysis of stimulation
        % electrode - recording electrode pair. Returns estimates of
        % stimulation artifact with interpretationVec associated stating
        % which estimates (rows of artifactEstimations) are correct.
        % Additionally it provides list of all spikes detected untill 100%
        % stimulation saturation amplitude.
        % Input:
        %     stimEle(Int): ID of stimulation electrode
        %     recEle(Int): ID of recording electrode
        % Output:
        %     interpretationVector(Vector<Boolean>): ones in this
        %          vectors represents proper artifact estimate, while
        %          zeros suggests estimate of artifact plus spike.
        %     meanArtsMat(Array<Float>): each row of the array represents
        %         stimulation artifact for consecutive amplitude whose IDs
        %         are spiecified in dataSetObj.movies field.
        %     spikeMatrix(Array<Float>): a matrix where each row
        %         represents detected spike with columns as follows:
        %             1) ampitude(Float): amplitude of stimulation current
        %                 in nA.
        %             2) repetition(Int):  i, if spike occured as response
        %                 to ith stimulus, 
        %             3) timing(Float): interpolated timing of spike (when
        %                  voltage reaches the half-amplitude of the spike)
            allTraces = dataSetObj.getAllTracesForSEREpair(stimEle, recEle, dataSetObj.movies);
            artifactEstimations = dataSetObj.getMeanArtsForMovies(allTraces, stimEle, recEle, dataSetObj.movies);
            spikeMatrix = dataSetObj.detectSpikesForAllMovies(allTraces, artifactEstimations, stimEle, recEle, dataSetObj.movies);
            spikeDetectedVec = dataSetObj.transformSpikeMatToVec(spikeMatrix, dataSetObj.movies);
            interpretationVec = logical(dataSetObj.interpretResults(spikeDetectedVec));
            spikeMatrix = dataSetObj.translateSpikeMatrix(spikeMatrix);
        end
        %% find best electrode methods
        function fullEffIdx = giveMaximumEfficiencyAmpIdx(dataSetObj)
            allTraces = dataSetObj.getAllTracesForSEREpair(stimEle, recEle, dataSetObj.movies);
            artifactEstimations = dataSetObj.getMeanArtsForMovies(allTraces, stimEle, recEle, dataSetObj.movies);
            spikeMatrix = dataSetObj.detectSpikesForAllMovies(allTraces, artifactEstimations, stimEle, recEle, dataSetObj.movies);
            spikeDetectedVec = dataSetObj.transformSpikeMatToVec(spikeMatrix, dataSetObj.movies);
            fullEffIdx = dataSetObj.interpreterObj.findFullEffIdx(spikeDetectedVec); % Inf when not found
        end %% niepotrzebna?
        function [stimElectrodes, optimalAmps] = ...
                estimateBestStimAmpsForClosestEles(dataSetObj, primaryStimEle, recEle)
        % Method that computes optimal stimulation amplitude for multiple
        % SE-RE pairs. Recording electrode is always recEle, while
        % stimulation electrodes are primaryStimElectrodes and its
        % neighbouring electrodes.
        % Input:
        %     primaryStimeEle(Int): ID of electrode that along its closest 
        %         neighbours will be set as stimulations electrodes
        %     recElec(Int): ID of electrode that was used to record a
        %         signal
        % Output:
        %     stimElectrodes(Vector<Int>): vector of electrodes IDs used as
        %         stimulation electrodes
        %     optimalAmps(Vector(<Float>): vector of amplitudes selected by
        %         dataSetObj.stimAmpSelectorObj. optimalAmps(i) was chosen
        %         when ID of stimulation electrode was optimalAmps(i).
            stimElectrodes = dataSetObj.giveNeigbouringEles(primaryStimEle);
            optimalAmps = zeros(size(stimElectrodes));
            i = 0;
            for stimEle = stimElectrodes'
                i = i + 1;
                optimalAmps(i) = dataSetObj.giveOptimalStimAmpForSEREpair(stimEle,recEle);
            end
        end
        function bestEle = chooseBestStimulationElectrode(dataSetObj, recEle)
        % Method that allows to choose best stimulation electrode when
        % signal from recEle recording electrode is concerned. Its
        % closest neighbours and electrode itself are taken into
        % cosideration. Best stimulation electrode is defined, as an
        % electrode where stimulation current needed to attain desired
        % efficiency is the smallest.
        % Input:
        %     recEle(Int) - recording electrode, from which the signal is
        %         analyzed. It is also used as stimulation electrode (eg.
        %         we analyze signal from the same electrode that was used
        %         to deliver stimulus) alongside its neighbouring
        %         electrodes
        % Output:
        %     bestEle(int) - ID of electrode with smallest activation
        %         current
            [stimElectrodes, optimalAmps] = ... 
                dataSetObj.estimateBestStimAmpsForClosestEles(recEle, recEle);
            [minAmp, minIdx] = min(optimalAmps);
            if minAmp == Inf
                disp('Minimal required efficiency was not achieved on neither electrode')
                bestEle = 0;
            else
                bestEle = stimElectrodes(minIdx);
            end
            
        end
        %% fitting   
        function stimEfficacy = transformSpikeMatToEfficacy(dataSetObj, spikeMat, interpretationVec)
        % Extracts the stimulation efficacy by analyzing output of
        % dataSetObj.analyzeSEREpair method.
        % Input:
        %     interpretationVector(Vector<Boolean>): ones in this
        %          vectors represents proper artifact estimate, while
        %          zeros suggests estimate of artifact plus spike.
        %     spikeMatrix(Array<Float>): a matrix where each row
        %         represents detected spike with columns as follows:
        %             1) movie(Int): ID of stimulation amplitude,
        %             2) repetition(Int):  i, if spike occured as response
        %                 to ith stimulus, 
        %             3) sample(Float): interpolated index of a sample when
        %                 voltage reached half amplitude of a spike.
        % Output:
        %     stimEfficacy(Vector<Float>): stimulation efficacy (0 - 1.)
        %         for each consecutive stimulation 
            stimEfficacy = zeros(size(dataSetObj.currentAmps));
            i = 0;
            for amp = dataSetObj.currentAmps
                i = i + 1;
                if interpretationVec(i)
                    stimEfficacy(i) = sum(spikeMat(:,1) == amp) / dataSetObj.tracesNumberLimit;
                else
                    stimEfficacy(i:end) = 1;
                    break
                end
            end
        end
        function optimalAmp = selectOptimalStimAmp(dataSetObj, spikeMat, interpretationVec)
        % Uses dataSetObj.stimAmpSelectorObj to select optimal stimulation
        % amplitude based on outputs of dataSetObj.analyzeSEREpair method.
        % Optimal stimulation amplitude and the way it is selected is
        % defined in stimulation amplitude selector object.
        % Input:
        %     interpretationVector(Vector<Boolean>): ones in this
        %          vectors represents proper artifact estimate, while
        %          zeros suggests estimate of artifact plus spike.
        %     spikeMatrix(Array<Float>): a matrix where each row
        %         represents detected spike with columns as follows:
        %             1) movie(Int): ID of stimulation amplitude,
        %             2) repetition(Int):  i, if spike occured as response
        %                 to ith stimulus, 
        %             3) sample(Float): interpolated index of a sample when
        %                 voltage reached half amplitude of a spike.
        % Output:
        %     optimalAmp(Float): stimulation current amplitude in
        %         nanoamperes returned by stimulatiom amplitude selector
        %         object.
            minimalEfficacy = dataSetObj.applicationRange(1) / dataSetObj.tracesNumberLimit;
            stimEfficacy = dataSetObj.transformSpikeMatToEfficacy(spikeMat, interpretationVec);
            if max(stimEfficacy) < minimalEfficacy
                disp('Minimal efficacy requirement not met. Fitting not possible')
                optimalAmp = Inf;
            else
                optimalAmp = dataSetObj.stimAmpSelectorObj.selectAmplitude(dataSetObj.currentAmps, stimEfficacy);
            end
        end
        function optimalAmp = giveOptimalStimAmpForSEREpair(dataSetObj, stimEle, recEle)
        % Uses dataSetObj.stimAmpSelectorObj to select optimal stimulation
        % amplitude for stimulation electrode-recording electrode pair.
        % Optimal stimulation amplitude and the way it is selected is
        % defined in stimulation amplitude selector object.
        % Input:
        %     stimEle(Int): ID of stimulation electrode
        %     recEle(Int): ID of recording electrode
        % Output:
        %     optimalAmp(Float): stimulation current amplitude in
        %         nanoamperes returned by stimulatiom amplitude selector
        %         object.
            [interpretationVec,  artifactEstimates, spikeMatrix] = ...
                dataSetObj.analyzeSEREpair(stimEle, recEle);
            if dataSetObj.allArtifactsEstimated(artifactEstimates)
                optimalAmp = dataSetObj.selectOptimalStimAmp(spikeMatrix, interpretationVec);
            else
                optimalAmp = Inf;
                disp('Not all artifacts were estimated. Fitting not possible.')
            end
        end
        %% helper methods
        function neighbouringEles = giveNeigbouringEles(dataSetObj, electrode)
        % Method that returns IDs of electrodes next to specified one.
        % Input:
        %     electrode(Int): ID of electrode
        % Output:
        %     neighbouringEles(Vector<Int>): column vector containing
        %         specified electrode ID and IDs of its neighbours. The
        %         input electrode ID is always neighbouringEles(1).
            electrodeLayout = edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(500);
            neighbouringEles = electrodeLayout.getAdjacentsTo(electrode, 1);
        end
        function t = changeSampleToMiliseconds(dataSetObj, sample)
        % Changes samples to miliseconds using dataSetObj.samplingRate
        % field.
        % Input:
        %     sample(Float): A number representing sample from a onset (eg.
        %         number 5 representing 5th sample). Does not have to be
        %         iteger valued.
        % Output: t(Float): Time in miliseconds from the onset. 
            t = 1/dataSetObj.samplingRate * 1000 * sample;
        end
        function stimAmpUsed = extractStimulationAmplitudes(dataSetObj)
        % Fetches stimulation current amplitudes used durint
        % experimenations.
        % Output:
        %     stimpAmpUsed(Vector<Float>): amplitudes in nanoamperes used
        %         in the experiment ordered from the lowest to the highest.
            NS_GlobalConstants=NS_GenerateGlobalConstants(500);
            stimAmpUsed = zeros(size(dataSetObj.movies));
            i = 0;
            for movie = dataSetObj.movies
                i = i + 1;
                stimAmpUsed(i) = NS_AmplitudesForPattern_512_1el(dataSetObj.dataPath,0,1,movie,NS_GlobalConstants);
            end
        end
        function transedSpikeMat = translateSpikeMatrix(dataSetObj, spikeMat)
        % Changes units(samples -> miliseconds and amplitude indices 
        % to current in nA) in resultant matrix from 
        % dataSetObj.detectSpikesForAllMovies method.
        % Input:
        %    spikeMat(Array<Int>): columns in format: AmplitudeIndex,
        %        repetition, sample of spike onset.
        % Output:
        %     transedSpikeMat(Array<Float>): columns in format:
        %     Amplitude(nA), repetition, time of spike onset in
        %     miliseconds.
            if isempty(spikeMat) % no spikes were found
                transedSpikeMat = spikeMat;
            else
                transedSpikeMat = spikeMat;
                transedSpikeMat(:,3) = dataSetObj.changeSampleToMiliseconds(spikeMat(:,3));
                transedSpikeMat(:,1) = dataSetObj.currentAmps(transedSpikeMat(:,1));
            end
        end
        function spikeDetectedVec = transformSpikeMatToVec(dataSetObj, spikeMat, movies)
        % Extracts information from spike matrix returned by detectSpikesForAllMovies 
        % function how many spikes was detected for each amplitude.
        % Input:
        %     spikeMat(Array<Float>): a matrix where each row
        %         represents detected spike with columns as follows:
        %             1) movie(Int): ID of stimulation amplitude
        %             2) repetition(Int):  i, if spike occured as response
        %                 to i-th stimulus, 
        %             3) sample(Float): interpolated index of a sample when
        %                 voltage reached half amplitude of a spike.
        % Output:
        %    spikeDetectedVec(Vector<Int>): vector where each number
        %        represents how many spikes were detected for consecutive
        %        stimulation current amplitude.
            spikeDetectedVec = zeros(size(movies));
            for i = 1:length(movies)
                spikeDetectedVec(i) = sum(spikeMat(:,1) == i);
            end
        end
        function allEstimated = allArtifactsEstimated(dataSetObj, artifactEstimatesMatrix)
            allEstimatedVec = zeros(size(artifactEstimatesMatrix, 1), 1);
            for i = 1:length(allEstimatedVec)
                allEstimatedVec(i) = any(artifactEstimatesMatrix(i,:));
            end
            allEstimated = all(allEstimatedVec);
        end
    end
end