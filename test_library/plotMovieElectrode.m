function plotMovieElectrode(movieNo, electrodeNo)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER
    patternNumber = electrodeNo;
    [DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(...
        DATA_PATH,DATA_PATH,0,patternNumber,movieNo,TRACES_NUMBER_LIMIT,EVENT_NUMBER);
    electrodeTraces = squeeze(DataTraces(:, electrodeNo, :));
    plot(electrodeTraces');
    title(sprintf('movie: %d, electrode: %d', movieNo, electrodeNo));
end


% plotMovieElectrode(10, 16) 2 outliers
% plotMovieElectrode(9, 1) 3 clusters?

%interesujace przyklady (movie, ele) : (12, 1) 4 odpalwy w gore 1 w dol,
%(13, 1) - jeden odpal w dol i w gore (ten sam)
%(7,1) - typowy, 
% (3, 1) - 1 odpal w dol
% (18, 16)- 2(3?) odstajace. zrodlem jest odbiegajace zapamietanie napiecie
% poczatkowe?
% (16, 16) - 1 outlier
% (15, 16) - typical
% (14, 16) - 1 outlier w gore/ jeden w dol + typical?
% (13, 16) - 1 outlier + 3 klastry
% (11, 16) - 2 outliery w gore

% moze usuwac przebiegi, ktorych pierwsza probka odbiega o ilestam?