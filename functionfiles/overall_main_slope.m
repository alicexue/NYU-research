function overall_main_slope(task,expN,present,printFg)
%% Example
%%% overall_main_slope('easy',2,2,true);

%% Parameters
% task = 'easy'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = true; (if true, prints and saves figures)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFileName = '1';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    if present == 1
        saveFileName = '_2TP';
        titleName = 'TP';
    elseif present == 2
        saveFileName = '_2TA';
        titleName = 'TA';
    elseif present == 3
        saveFileName = '_2';
        titleName = '';
    end
end
%% Load the data
all_rt=[];
all_p=[];

numObs = 0;

files = dir('C:\Users\alice_000\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2) && ~strcmp(obs(1,1),'.')
        [rt,p] = p_main_slope(obs,task,expN,present,false);
        if ~isnan(p)
            all_rt = horzcat(all_rt,rot90(rt,-1));
            all_p = horzcat(all_p,rot90(p,-1));
            numObs = numObs + 1;
        end
    end
end

rt_m = nanmean(all_rt,2);
p_m = nanmean(all_p,2);

rt_sem = nanstd(all_rt,[],2)./sqrt(numObs);
p_sem = nanstd(all_p,[],2)./sqrt(numObs);

if printFg
    %% Plot rt
    figure; hold on;
    for i=1:numObs
        plot(100:30:460,all_rt(:,i)*1000,'-o','LineWidth',0.8,'MarkerFaceColor',[1 1 1],'MarkerSize',6)
    end

    errorbar(100:30:460,rt_m*1000,rt_sem*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

%     legend_obs = cell(numObs,1);
%     for i=1:numObs
%         legend_obs{i} = ['obs ' num2str(i)];
%     end
%     legend_obs{numObs+1} = 'average';
%     legend(legend_obs,'Location','NorthEast')

    if expN == 1
        ylim([0 1200])
        set(gca,'YTick', 0:200:1200,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    elseif expN == 2
        ylim([200 1800])
        set(gca,'YTick', 200:400:1800,'FontSize',15,'LineWidth',2,'Fontname','Ariel')     
    end
    title([condition ' Reaction Time (n = ' num2str(numObs) ') ' titleName],'FontSize',20)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('RT [ms] ','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_rtDelays' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot performance
    figure; hold on;
    for i=1:numObs
        plot(100:30:460,all_p(:,i)*100,'-o','LineWidth',0.8,'MarkerFaceColor',[1 1 1],'MarkerSize',6)
    end

    errorbar(100:30:460,p_m*100,p_sem*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

%     legend_obs = cell(numObs,1);
%     for i=1:numObs
%         legend_obs{i} = ['obs ' num2str(i)];
%     end
%     legend_obs{numObs+1} = 'average';
%     legend(legend_obs,'Location','SouthWest')

    if expN == 1
        ylim([50 100])
        set(gca,'YTick', 50:10:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    elseif expN == 2
        ylim([30 100])
        set(gca,'YTick', 30:10:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    end
    title([condition ' Performance (n = ' num2str(numObs) ') ' titleName],'FontSize',20)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_PerfDelays' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end
end