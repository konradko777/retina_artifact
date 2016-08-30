DATA_PATH = 'E:\praca\dane_2016_08\2014-11-05-3\data001\';
succes = {};

i = 0;
for file_ = dir([DATA_PATH 'elecResp*'])'
    i = i + 1;
    load([DATA_PATH file_.name])
    succes{i} = elecResp.analysis.successRates;
    sprintf('%d, %d', any(succes{i}), any(cellfun(@any, elecResp.analysis.otherLatencies)))
end