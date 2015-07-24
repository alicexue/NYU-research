function overall_perf1_slope(task)
%% Example
%%% overall_perf1_slope('difficult')

%% Parameters
% task = 'difficult'

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

perf_avg = [];
rt_median = [];
numObs = 0;
files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if fileL == 2 && ~strcmp(obs(1,1),'.')
        [rt_m,p_avg] = p_perf1_slope(obs,task,true);
        perf_avg = horzcat(perf_avg,p_avg); 
        rt_median = horzcat(rt_median,rt_m);
        numObs = numObs + 1;
    end
end

%% Plot performance
figure; hold on;
p = zeros(1,15);
p_sem = zeros(1,15);
for delay = 1:size(perf_avg,1)
    p(delay) = mean(perf_avg(delay,:,:));
    p_sem(delay) = (std(perf_avg(delay,:,:))/sqrt(numObs));
end

errorbar(40:30:460,p*100,p_sem*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Performance'],'FontSize',20)
xlabel('Time from search array onset','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_PerfDelays']);
print ('-djpeg', '-r500',namefig);

%% Plot rt
figure; hold on;
rt = zeros(1,15);
rt_sem = zeros(1,15);
for delay = 1:size(rt_median,1)
    rt(1,delay) = median(rt_median(delay,:));
    rt_sem(1,delay) = (std(rt_median(delay,:))/sqrt(numObs));
end

errorbar(40:30:460,rt*1000,rt_sem*1000,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([0 3000])
set(gca,'YTick', 0:500:3000,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
title([condition ' Reaction Time'],'FontSize',20)
xlabel('Time from search array onset','FontSize',15,'Fontname','Ariel')
ylabel('RT [ms] ','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_rtDelays']);
print ('-djpeg', '-r500',namefig);
end
