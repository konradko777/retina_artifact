function plot4colors(traces, bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes)
    plotSelectedTraces(traces, bothSpikes, 'g')
    plotSelectedTraces(traces, onlyStep2Arts, 'm')
    plotSelectedTraces(traces, bothArts, 'r')
    plotSelectedTraces(traces, onlyStep2Spikes, 'c')

end