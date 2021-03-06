%Skrypt definiuje wszystki interesujace nas neurony, potem dla kazdego
%interesujacego neuronu definiuje jego Primary Stimulating Electrode, potem
%dla kazdej z 61 elektrod wczytuje odpowiedni plik z wynikami recznej
%klasyfikacji przebiegow.

clear;
%0) Definicja sciezek
ClusterFilePath='C:\Copy\NAUKA\Implant\data003\ClusterFile_003_id';

%1) zaladuj mape elektrod
NS_GlobalConstants=NS_GenerateGlobalConstants(61);
electrodeMap=edu.ucsc.neurobiology.vision.electrodemap.ElectrodeMapFactory.getElectrodeMap(1);
for i=1:64
    ElectrodesCoordinates(i,1)=electrodeMap.getXPosition(i);
    ElectrodesCoordinates(i,2)=electrodeMap.getYPosition(i);
end

BoxLineWidth=2;
ElectrodeMap([1:6 16 7 8 10:11 18 12:15 17 27 19:24 26 28 29:36 37 38:44 45 46:50 51:54 55:56 60 58:59 61:64])=[1:61];

%2) Zaladuj wszystkie wykorzystane amplitudy
for i=1:26    
    [StimChannels,Amplitudes]=NS_StimulatedChannels('C:\Copy\NAUKA\Implant\data003',45,i,[1:64],NS_GlobalConstants);
    Amps(i)=Amplitudes;
end

%3) Zdefiniuj numery neuronow do analizy oraz ich Primary Stimulating Electrodes
NeuronsIDs=[76 227 256 271 391 406 541 616 691 736 856 901];
StEl=[1 16 18 10 27 28 37 45 54 51 60 61];

%4) Odczytaj Cluster File
Electrodes=[1:8 10:24 26:56 58:64]; %Dla ktorych elektrod stymulujacych chcemy odczytac dane - w praktyce nie dla wszystkich
for i=1:12 % dla kazdego neuronu...
    %i=k
    ClusterFileName=[ClusterFilePath num2str(NeuronsIDs(i))] % to jest nazwa Cluster File dla danego neuronu
    for Pattern=Electrodes % dla ka?dej z 61 elektro matrycy...        
        for Movie=1:26 %dla ka?dego movie - czyli dla ka?dej amplitudy (jedno movie to stymulacja wszystkich elektrod dla jednej amplitudy)
            WaveformTypes=NS_ReadClusterFile(ClusterFileName,Movie,Pattern,50); %kazdemu z 50 przebiegów przypisany jest typ: 1 - czysty artefakt, 2 - spike
            Eff(Movie)=length(find(WaveformTypes==2))/length(WaveformTypes)*100; %efektywnosc stymulacji danego neuronu dana elektroda przy danej amplitudzie
        end
    end
end

break;
%5) Jak wczytac preprocessed data:
DataPath='C:\Copy\NAUKA\Implant\data003';
TracesNumberLimit=50;
EventNumber=0;

PatternNumber=1;
MovieNumber=15;
[DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(DataPath,DataPath,0,PatternNumber,MovieNumber,TracesNumberLimit,EventNumber);

%wyciagamy z danych przebiegi dla jednej elektrody:
ElectrodeNumber=1;
Data1=DataTraces(:,ElectrodeNumber,:);
Data2=reshape(Data1,50,70);
figure
plot(Data2');