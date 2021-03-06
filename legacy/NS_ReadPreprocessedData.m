function [DataTraces,ArtifactDataTraces,Channels]=NS_ReadPreprocessedData(DataPath,ArtifactDataPath,ArtifactSubtraction,PatternNumber,MovieNumber,TracesNumberLimit,EventNumber);
%This function reads the output data produced by the prerpocessing function
%(NS_PreprocessData or its variations). 
%ArtifactSubtraction: if equal to 1, data including artifact only recorded
%with TTX are recorded, averaged, and the average traces are subtracted
%from the data traces
%EventNumber - sometimes pulse on one electrode is repeated twice during
%the same movie (for example, two different orders of stimulating
%electrodes are tried). In such case, EventNumber defines whether the
%responses to the first or the second (or other) pulse should be given by
%this function. If EventNumber==0, all responses are given.

if ArtifactSubtraction==1
    FullName=[ArtifactDataPath filesep 'p' num2str(PatternNumber) '_m' num2str(MovieNumber)];
    fid=fopen(FullName,'r','ieee-le');
    b=fread(fid,'int16');    
    fclose(fid);
    b0=b(1:1000);
    b1=b(1001:length(b));
    ArtifactDataTraces=reshape(b1,b0(1),b0(2),b0(3));
    Channels=b0(3+1:3+b0(2));
    Artifact=mean(ArtifactDataTraces);
    b0art=b0;
end

FullName=[DataPath filesep 'p' num2str(PatternNumber) '_m' num2str(MovieNumber)];
fid=fopen(FullName,'r','ieee-le');
b=fread(fid,'int16');
%size(b)
fclose(fid);
b0=b(1:1000);
b1=b(1001:length(b));
DataTraces=reshape(b1,b0(1),b0(2),b0(3));
Channels=b0(3+1:3+b0(2));
NumberOfEvents=b0(4+b0(2));

if ArtifactSubtraction==1
    for i=1:b0(1)
        DataTraces(i,:,:)=DataTraces(i,:,:)-Artifact;
    end
else
    ArtifactDataTraces=DataTraces;
end

if length(EventNumber)>1
    DataTraces=DataTraces(EventNumber,:,:);
else
    if EventNumber~=0
        DataTraces=DataTraces(EventNumber:NumberOfEvents:b0(1),:,:);
    end
end

SDT=size(DataTraces);

if (TracesNumberLimit~=0 & TracesNumberLimit<SDT(1))
    DataTraces=DataTraces(1:TracesNumberLimit,:,:);
    %ArtifactDataTraces=ArtifactDataTraces(1:TracesNumberLimit,:,:);
end