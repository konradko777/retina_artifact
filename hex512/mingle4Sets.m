function [bothSpikes, bothArts, onlyStep2Arts, onlyStep2Spikes] = mingle4Sets(step1Arts, step1Spikes, step2Arts,step2Spikes)
            bothSpikes = intersect(step2Spikes, step1Spikes);
            bothArts = intersect(step2Arts, step1Arts);
            onlyStep2Arts = setdiff(step2Arts,step1Arts);
            onlyStep2Spikes = setdiff(step2Spikes, step1Spikes);
end