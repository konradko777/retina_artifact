function findBestRecordingEle(MovieNumber)
    clusterFileNames = {'data003\ClusterFile_003_id901'};
%     clusterFileNames = {'data003\ClusterFile_003_id76';
%                      'data003\ClusterFile_003_id227'};

    for i = 1:length(clusterFileNames)
        fileName = clusterFileNames{i};
        plotSpikeFromClustFile(fileName, MovieNumber)
    end
    
end

function neuronID = getNeuronID(ClusterFileName)
    global NEURON_ELE_MAP
    index_ = strfind(ClusterFileName, 'id');
    neuronID = str2num(ClusterFileName(index_ + 2 : end));
end


function map = createNeuronMovieMap()
    neurons = [76 227 256 271 391 406 541 616 691 736 856 901];
    movies = [8 6 18 15 10 17 11 1 2 8 9 21];
    electrode = [1 16 18 9999999 27 28 37 45 54 50 58 61];
    %271 skokowe przejscie w amplitudzie, trudne do rozroznienia
    %niecentralne 736 856

end 