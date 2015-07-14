function p_search_slope(obs, date, oneBlock, blockN, task)

%%% Example
%%%  p_search_slope('ax', '150709', false, 5,'difficult')

%% Parameters

%obs = 'ax';
%date = '150709';
%oneBlock? = false;
%blockN = 5;
%task = 'difficult'

% if oneBlock == true, then only blockN is analyzed
% if oneBlock == false, then the blocks with a number < blockN are analyzed

%% Obtain pboth, pone and pnone for each run and concatenate over run
rt4_avg=[];
rt8_avg=[];
perf4_avg=[];
perf8_avg=[];
strOneBlock = 'T';
used_date = date;
if oneBlock == true 
    [rt4,rt8,perf4,perf8] = search_slope(used_date,obs,blockN,task);

    rt4_avg = rt4;
    rt8_avg = rt8;
    perf4_avg = perf4;
    perf8_avg = perf8;
    %rt4_avg = [rt4_avg,rt4];
    %rt8_avg = [rt8_avg,rt8];
    %perf4_avg = [perf4_avg,perf4];
    %perf8_avg = [perf8_avg,perf8];
else 
    strOneBlock = 'F';
    for i = 1:blockN;
        if blockN < 10
            s = ['C:\Users\Alice\Documents\MATLAB\data\', obs, '\', task, '\', date, '_stim0',num2str(i),'.mat'];
            existent = exist(s,'file');
        elseif blockN >= 10
            s = ['C:\Users\Alice\Documents\MATLAB\data\', obs, '\', task, '\', date, '_stim',num2str(i),'.mat'];
            existent = exist(s,'file');
        end

        if existent ~= 0
            [rt4,rt8,perf4,perf8] = search_slope(used_date,obs,i,task);

            rt4_avg = horzcat(rt4_avg,rt4);
            rt8_avg = horzcat(rt8_avg,rt8);
            perf4_avg = horzcat(perf4_avg,perf4);
            perf8_avg = horzcat(perf8_avg,perf8);
            %rt4_avg = [rt4_avg,rt4];
            %rt8_avg = [rt8_avg,rt8];
            %perf4_avg = [perf4_avg,perf4];
            %perf8_avg = [perf8_avg,perf8];
        end
    end
end

%% Plot reaction time
rt = [mean(rt4_avg) mean(rt8_avg)];
rt_std = [std(rt4_avg) std(rt8_avg)];

figure;hold on;
errorbar(4:4:8,rt*1000,rt_std*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')
ylim([0 1000])
%set(gca,'YTick', 50:10:100)

% title([obs ' ' condition],'FontSize',14)
xlabel('set size','FontSize',25,'FontName','Times New Roman')
ylabel('RT (ms)','FontSize',25,'FontName','Times New Roman')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\rt\' 'rtSetSize' strOneBlock num2str(blockN)]);
print ('-djpeg', '-r500',namefig);

%% Plot performance
p = [mean(perf4_avg) mean(perf8_avg)];
p_std = [std(perf4_avg) std(perf8_avg)];

figure;hold on;
errorbar(4:4:8,p*100,p_std*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')
ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')

% title([obs ' ' condition],'FontSize',14)
xlabel('set size','FontSize',25,'FontName','Times New Roman')
ylabel('Accuracy','FontSize',25,'FontName','Times New Roman')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\perf\' 'perfSetSize' strOneBlock num2str(blockN)]);
print ('-djpeg', '-r500',namefig);

end