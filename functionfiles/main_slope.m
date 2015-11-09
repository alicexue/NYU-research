function [perfDelays,rtDelays] = main_slope(obs,task,file,expN,present)
%% Example
% main_slope('ax','difficult','150716_stim01.mat');

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150716_stim01.mat';

%% Load data
if expN == 1
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])
elseif expN == 2
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\' file])

%% Transform data
exp = getTaskParameters(myscreen,task);
theTrials = find(task{1}.randVars.fixBreak == 0);
nTrials = size(theTrials,2);

%% Compute rt for each delay
rt = zeros(1,600);
rtDelays = zeros(13,nTrials/13);

rtTmp = exp.reactionTime;
noFixBreakIndices = find(~isnan(rtTmp));

for n = 1:size(noFixBreakIndices,2)
    rt(n) = rtTmp(noFixBreakIndices(n));
end

for delays = unique(exp.randVars.delays) 
    tmp2 = exp.randVars.delays(theTrials)==delays;
    a = rt(tmp2);
    rtDelays(delays,:) = a;
end
%% Compute performance for each delay
perfTmp = zeros(1,600);
perfDelays = zeros(13,nTrials/13);
for n = 1:size(exp.randVars.targetOrientation,2)
    orientation = exp.randVars.targetOrientation(n);
    response = exp.response(n);
    if expN == 1
        if (orientation == 1 && response == 1) || (orientation == 2 && response == 2)
            perfTmp(n) = 1;
        else
            perfTmp(n) = 0;
        end
    elseif expN == 2
        presence = exp.randVars.presence(n);
        if (orientation == 1 && response == 1) || (orientation == 2 && response == 2) || (presence == 2 && response == 3)
            perfTmp(n) = 1;
        else
            perfTmp(n) = 0;
        end
    end 
end
perfTmp = perfTmp(1,1:n);

for n = 1:size(noFixBreakIndices,2)
    perf(n) = perfTmp(noFixBreakIndices(n));
end

for delays = unique(exp.randVars.delays)
    perfDelays(delays,:) = perf(exp.randVars.delays(theTrials)==delays);
end
perfDelays = mean(perfDelays,2); 

end
