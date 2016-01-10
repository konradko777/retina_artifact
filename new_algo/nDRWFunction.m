function [ NumberOfDRW ] = nDRWFunction(Waveforms, Artifact, QuantTh, samplesLim)

    nDRW = 0; % number of disqualifying resultant waveforms
    nWaveforms = size(Waveforms,1); % number of traces in event
    resultantWaveforms = Waveforms(:,:)-repmat(Artifact,nWaveforms,1); % generate Resultant Waveforms
    resultantWaveforms(:,samplesLim(2):end) = []; % We use only 40 first samples
    resultantWaveforms(:,1:samplesLim(1)) = []; % We skip 8 first samples (due to stimulation)
    % 150 us -> 8
    % 300 us -> 11 (albo 10...)
    % Aaaaaaaaaaaaaa!!!
    % dla tych nowych, testowych pomijamy 11 pierwszych probek!!!
    
    % Quantization to {-1, 0, 1} with the given threshold (QuantTh):
    quantizedWaveforms = zeros(size(resultantWaveforms));
    quantizedWaveforms(resultantWaveforms > QuantTh) = 1;
    quantizedWaveforms(resultantWaveforms < -QuantTh) = -1;
    
    % If first, nonzero element is plus one, we detect Disqualifying
    % Resultant Waveform...
    for iQWave = 1:size(quantizedWaveforms,1)
        sequence = quantizedWaveforms(iQWave,:);
        sequence(sequence == 0) = [];
        if ~isempty(sequence) && sequence(1) == 1
            nDRW = nDRW + 1;
        end
    end
    
    NumberOfDRW = nDRW;
    
end

