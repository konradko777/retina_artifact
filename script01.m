clc

%javaaddpath('C:\Copy\NAUKA\Implant\scripts\Vision.jar')

%NS_retina61_stim_eff_map_2015_03_31_MWysocki_simple

N = 26;

artifactsQuantity = zeros(N, 1);

for l =  5 %5

    for k =  10:5:80 %30
        for i = 1:N
            hold off
            DataPath='C:\Copy\NAUKA\Implant\data003';
            TracesNumberLimit=50;
            EventNumber=0;

            PatternNumber=16;
            MovieNumber=i;
            [DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(DataPath,DataPath,0,PatternNumber,MovieNumber,TracesNumberLimit,EventNumber);

            %wyciagamy z danych przebiegi dla konkretnej elektrody:
            ElectrodeNumber=16;
            Data1=DataTraces(:,ElectrodeNumber,:);
            Data2=reshape(Data1,50,70);
            %figure
            QuantTh = k;
            MinArtifactsNoToEstimate = l;

            subplot(2, 1, 1);
            plot(Data2', 'b');
            hold on
            title(sprintf('Patterm%d-MovieNumber%d-QuantTh%d-MinArtifactsNoToEstimate%d',PatternNumber,MovieNumber, QuantTh, MinArtifactsNoToEstimate));


            artifacts = mgrEstimateArtifactSignal_SIMPLE(Data2, QuantTh, MinArtifactsNoToEstimate);

            artifactsQuantity(i) = 50 - length(artifacts);

            meanArtifacts = zeros(70, 1);
            for j = 1 : length(artifacts)
                meanArtifacts = meanArtifacts + Data2(artifacts(j), :)';
            end
            meanArtifacts = meanArtifacts/length(artifacts);

            plot(meanArtifacts, 'r', 'LineWidth',2.5)
            legend('Spike + artifact/pure artifact', 'Averaged artifact', 'Location','southeast')
            hold off

            clearSignal = zeros(50,70);
            for j = 1: 50
                clearSignal(j,:) = Data2(j, :)' - meanArtifacts;       
            end

            subplot(2, 1, 2);
            plot(clearSignal', 'g','LineWidth',0.7)
            hold on
            for j = 1 : length(artifacts)
                hold on
                plot(clearSignal(artifacts(j), :)', 'r', 'LineWidth',0.7)
            end

            legend('Pure spike', 'Pure artifact - averaged artifact',  'Location','southeast')

            print(sprintf('.\\results\\pure_%d_%d_%d_%d',PatternNumber,MovieNumber, QuantTh, MinArtifactsNoToEstimate),'-dpng')

            hold off

            %display(artifacts);
            hold off
        end

        subplot(1,1,1);
        plot(artifactsQuantity)
        fileName = sprintf('.\\results\\artifactsQuantity_%d_%d_%d',PatternNumber, QuantTh, MinArtifactsNoToEstimate);
        print(fileName,'-dpng')

    end
end