function [pb,po,pn,pbp,pop,pnp,pboth,pone,pnone] = probe_analysis(obs,task,file,expN,present)
%% This program analyzes the probe task

%% Example
%%% probe_analysis('ax','difficult','150820_stim01.mat',1,1);

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150716_stim01.mat';
% expN = 2; % which experiment
% present = 1; % only a valid input for exp 2
% if present = 1, target present trials are outputted
% if present = 2, target absent trials are outputted
% if present = 3, all trials of experiment 

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
%         theTrials = find(task{1}.randVars.fixBreak == 0 & task{1}.randVars.presence == 1);        
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        tmp = size(theTrials1,2);    
        theTrials2 = find(task{1}.randVars.presence == 1);
        tmp2 = theTrials2 <= tmp;
        theTrials = theTrials2(tmp2);        
    elseif present == 2
%         theTrials = find(task{1}.randVars.fixBreak == 0 & task{1}.randVars.presence == 2);
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        tmp = size(theTrials1,2);    
        theTrials2 = find(task{1}.randVars.presence == 2);
        tmp2 = theTrials2 <= tmp;
        theTrials = theTrials2(tmp2);   
    end
end

nTrials = size(theTrials,2);

%% Revert the order of the list
pboth = zeros(1,1000);
pnone = zeros(1,1000);
pone = zeros(1,1000);

q = 1;
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
                pboth(q) = 1;pnone(q) = 0;pone(q) = 0;
            elseif ((cor1 == 1) && (cor2 == 0))||((cor1 == 0) && (cor2 == 1))
                pboth(q) = 0;pnone(q) = 0;pone(q) = 1;
            elseif (cor1 == 0) && (cor2 == 0)
                pboth(q) = 0;pnone(q) = 1;pone(q) = 0;
            end
        end       
    end   
    q = q + 1;
end

pboth = pboth(1,1:nTrials);
pnone = pnone(1,1:nTrials);
pone = pone(1,1:nTrials);

% t = nTrials/13;
% pb = zeros(13,t);
% po = zeros(13,t);
% pn = zeros(13,t);

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
    
% %     pb(delays,:) = pboth(delayTrials);
% %     po(delays,:) = pone(delayTrials);
% %     pn(delays,:) = pnone(delayTrials);
%     pb(delays,:) = nanmean(pboth(delayTrials));
%     po(delays,:) = nanmean(pone(delayTrials));
%     pn(delays,:) = nanmean(pnone(delayTrials));

end

% t = t/12;
% pbp = zeros(13,t,12);
% pop = zeros(13,t,12);
% pnp = zeros(13,t,12);

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
        
        
% %         pbp(delays,:,pair) = pboth(delaysTrials & pairTrials);
% %         pop(delays,:,pair) = pone(delaysTrials & pairTrials);
% %         pnp(delays,:,pair) = pnone(delaysTrials & pairTrials);
%         pbp(delays,:,pair) = nanmean(pboth(delaysTrials & pairTrials),2);
%         pop(delays,:,pair) = nanmean(pone(delaysTrials & pairTrials),2);
%         pnp(delays,:,pair) = nanmean(pnone(delaysTrials & pairTrials),2);
    end
end
end

