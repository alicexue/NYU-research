function [perf,pTP,pTA,perfClicks,perfClicksP] = p_probe_performance(obs,task,expN,present,printFg,grouping)
%% Example
%%% p_probe_performance('ax','difficult',2,2,true,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = false; (if true, prints and saves figures

%% Outputs
% perf is a 13x1 matrix for overall probe performance at each delay
% pTP is a 13x1 matrix for overall probe performance at each delay when the
% target location is probed
% pTA is a 13x1 matrix for overal probe performance at each delay when the
% target location is not probed

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\figures\' obs '_' condition];
    saveFilePairsLoc = ['\main_' task '\figures\pairs\' obs '_' condition];
    saveFileName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\figures\' obs '_' condition];
    saveFilePairsLoc = ['\target present or absent\main_' task '\figures\pairs\' obs '_' condition];
    if present == 1
        saveFileName = '_2TP';
    elseif present == 2
        saveFileName = '_2TA';
    elseif present == 3
        saveFileName = '_2';
    end
end

%% Obtain perf for each run and concatenate over each run
perf = NaN(13,10000);
pTP = NaN(13,10000);
pTA = NaN(13,10000);
pClick1 = [];
pClick2 = [];
pClick1P = [];
pClick2P = [];
c = 1;

if expN == 1
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\main_', task]);  
elseif expN == 2
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\target present or absent\main_', task]);  
end

for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [p,pTargetP,pTargetA,pClicks,pClickPairs] = probe_performance(obs,task,filename,expN,present,grouping);
        perf(:,c) = p; 
        pTP(:,c) = pTargetP;
        pTA(:,c) = pTargetA;
        pClick1 = horzcat(pClick1,pClicks(:,:,1));
        pClick2 = horzcat(pClick2,pClicks(:,:,2));
        pClick1P = horzcat(pClick1P,pClickPairs(:,1,:));
        pClick2P = horzcat(pClick2P,pClickPairs(:,2,:));
        c = c + 1;
    end
end

perf = perf(:,1:c-1);
pTP = pTP(:,1:c-1);
pTA = pTA(:,1:c-1);

perf = nanmean(perf,2);
pTP = nanmean(pTP,2);
pTA = nanmean(pTA,2);

perfClicks = cat(3,nanmean(pClick1,2),nanmean(pClick2,2));

perfClicksP = cat(2,nanmean(pClick1P,2),nanmean(pClick2P,2));

if printFg
    %% Plot performance
    figure; hold on;
    plot(100:30:460,perf*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 100])
    xlim([0 500])
    set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Probe Performance (' obs ')'],'FontSize',18)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    
    plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')
    
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_probePerf']);
    print ('-djpeg', '-r500',namefig);
    
    %% Plot performance when target location is probed
    figure; hold on;
    plot(100:30:460,pTP*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 100])
    xlim([0 500])
    set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Performance-target loc probed (' obs ')'],'FontSize',15)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')
    
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_probePerfTP']);
    print ('-djpeg', '-r500',namefig);    
    
    %% Plot performance when target location is not probed
    figure; hold on;
    plot(100:30:460,pTA*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 100])
    xlim([0 500])
    set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Performance-target loc not probed (' obs ')'],'FontSize',15)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    
    plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')
    
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_probePerfTA']);
    print ('-djpeg', '-r500',namefig);       
end
end