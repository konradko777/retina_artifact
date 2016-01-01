function plotAllMoviesForEle(electrodeNo)
    global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER
    patternNumber = electrodeNo;
    movies = 1:24;
    nMovies = length(movies);
    half = nMovies / 2;
    for i = 1:nMovies
        movieNo = movies(i);
        [DataTraces, ~, ~]=NS_ReadPreprocessedData(...
            DATA_PATH,DATA_PATH,0,patternNumber,movieNo,TRACES_NUMBER_LIMIT,EVENT_NUMBER);
        electrodeTraces = squeeze(DataTraces(:, electrodeNo, :));
        figure
        plot(electrodeTraces');
        title(num2str(movieNo));
    end
end

% function plotAllMoviesForEle(electrodeNo)
%     global DATA_PATH TRACES_NUMBER_LIMIT EVENT_NUMBER
%     patternNumber = electrodeNo;
%     movies = 1:24;
%     nMovies = length(movies);
%     half = nMovies / 2;
%     for i = 1:half
%         movieNo = movies(i);
%         [DataTraces, ~, ~]=NS_ReadPreprocessedData(...
%             DATA_PATH,DATA_PATH,0,patternNumber,movieNo,TRACES_NUMBER_LIMIT,EVENT_NUMBER);
%         electrodeTraces = squeeze(DataTraces(:, electrodeNo, :));
%         subplot(3,4,i);
%         plot(electrodeTraces');
%         title(num2str(movieNo));
%     end
%     
%     figure
%     for i = half:nMovies;
%         movieNo = movies(i);
%         [DataTraces, ~, ~]=NS_ReadPreprocessedData(...
%             DATA_PATH,DATA_PATH,0,patternNumber,movieNo,TRACES_NUMBER_LIMIT,EVENT_NUMBER);
%         electrodeTraces = squeeze(DataTraces(:, electrodeNo, :));
%         subplot(3,4,i - half + 1);
%         plot(electrodeTraces');
%         title(num2str(movieNo));
%     end
% end

