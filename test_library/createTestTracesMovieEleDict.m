function [ tracesDictionary ] = createTestTracesMovieEleDict
    labels = {'typical', '1outlier', '2outliers', '3clusters'};
    movieElectrode = {[7 1] [13 16] [10 16] [9 1]};
    tracesDictionary = containers.Map(labels, movieElectrode);



end


% plotMovieElectrode(10, 16) 2 outliers
% plotMovieElectrode(9, 1) 3 clusters?

%interesujace przyklady (movie, ele) : (12, 1) 4 odpalwy w gore 1 w dol,
%(13, 1) - jeden odpal w dol i w gore (ten sam)
%(7,1) - typowy, 
% (3, 1) - 1 odpal w dol
% (18, 16)- 2(3?) odstajace. zrodlem jest odbiegajace zapamietane napiecie
% poczatkowe?
% (16, 16) - 1 outlier
% (15, 16) - typical
% (14, 16) - 1 outlier w gore/ jeden w dol + typical?
% (13, 16) - 1 outlier + 3 klastry
% (11, 16) - 2 outliery w gore