function [pb,po,pn,pbp,pop,pnp,pboth,pone,pnone] = probe_analysis(obs,task,file,expN,present)
%% This program analyzes the probe task for individual stim files
%% Example
%%% probe_analysis('ax','difficult','150820_stim01.mat',1,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150716_stim01.mat'; (name of stim file)
% expN = 2; (1 or 2)
% present = 1; (only relevant for exp == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials) 

%% Load the data
if expN == 1
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])
elseif expN == 2
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\' file])
end

%% Get Probe data
%%% Probe identity
identity = [1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0];

%%% Probe positions
positions = [-16 -13.25 -10.5 -7.75 -5 -2.25 0.5 3.25 6 8.75 11.5 14.25];

exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;

if expN == 1 || (expN == 2 && present == 3)
    theTrials = find(task{1}.randVars.fixBreak == 0);
elseif expN == 2
    if present == 1       
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 1);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp);
    elseif present == 2
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 2);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp); 
    end
end

%% Revert the order of the list
pboth = NaN(1,1000);
pnone = NaN(1,1000);
pone = NaN(1,1000);

% theTrials contains the trial numbers for the conditions set by the parameters 
index = 1;
for n = theTrials
    if n <= size(expProbe.probeResponse1,2)
        if ~isempty(expProbe.probeResponse1{n})
            idx1 = find(positions == expProbe.probeResponse1{n});
            idx2 = find(positions == expProbe.probeResponse2{n});
            i = 11;
            for a = 1:12
                idx1 = idx1 + i;
                idx2 = idx2 + i;
                i = i - 2;
            end

            selected_idx1 = expProbe.list{n}==idx1;
            selected_idx2 = expProbe.list{n}==idx2;
            reported1 = identity(selected_idx1,:);
            reported2 = identity(selected_idx2,:);
            presented1 = expProbe.probePresented1{n};
            presented2 = expProbe.probePresented2{n};

            cor1 = 0;
            cor2 = 0;
            if (reported1(1)==presented1(1))&&((reported1(2)==presented1(2)))...
                    || (reported1(1)==presented2(1))&&((reported1(2)==presented2(2)))
                cor1 = 1;
            elseif (reported2(1)==presented1(1))&&((reported2(2)==presented1(2)))...
                    || (reported2(1)==presented2(1))&&((reported2(2)==presented2(2)))
                cor2 = 1;
            else
                cor1 = 0;
                cor2 = 0;
            end
            if (reported2(1)==presented1(1))&&((reported2(2)==presented1(2)))...
                    || (reported2(1)==presented2(1))&&((reported2(2)==presented2(2)))
                cor2 = 1;
            end

            if (cor1 == 1) && (cor2 == 1)
                pboth(index) = 1;pnone(index) = 0;pone(index) = 0;
            elseif ((cor1 == 1) && (cor2 == 0))||((cor1 == 0) && (cor2 == 1))
                pboth(index) = 0;pnone(index) = 0;pone(index) = 1;
            elseif (cor1 == 0) && (cor2 == 0)
                pboth(index) = 0;pnone(index) = 1;pone(index) = 0;
            end
        end       
    end   
    index = index + 1;
end

pboth = pboth(1,1:index-1);
pnone = pnone(1,1:index-1);
pone = pone(1,1:index-1);

pb = NaN(13,200);
po = NaN(13,200);
pn = NaN(13,200);

for delays = unique(exp.randVars.delays)
    delayTrials = exp.randVars.delays(theTrials)==delays;
    tmp = pboth(delayTrials);
    pb(delays,1:size(tmp,2)) = tmp;
    tmp = pone(delayTrials);
    po(delays,1:size(tmp,2)) = tmp;
    tmp = pnone(delayTrials);
    pn(delays,1:size(tmp,2)) = tmp;
end

pbp = NaN(13,100,12);
pop = NaN(13,100,12);
pnp = NaN(13,100,12);

for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        delaysTrials = exp.randVars.delays(theTrials)==delays;
        pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
        tmp = pboth(delaysTrials & pairTrials);
        pbp(delays,1:size(tmp,2),pair) = tmp;
        tmp = pone(delaysTrials & pairTrials);
        pop(delays,1:size(tmp,2),pair) = tmp;
        tmp = pnone(delaysTrials & pairTrials);
        pnp(delays,1:size(tmp,2),pair) = tmp;
    end
end
end

