function dict = createAmpMovieMap(datapath)
    MOVIES = (1:32)*2 - 1;
    NS_GlobalConstants=NS_GenerateGlobalConstants(500);
    amps = zeros(size(MOVIES));
    i = 1;
    for movie = MOVIES
         amps(i) = NS_AmplitudesForPattern_512_1el(datapath,0,1,movie,NS_GlobalConstants);
         i = i + 1;
    end
    dict = containers.Map(amps, MOVIES);

end