clear; clc;
load_dir = './results/';
image_dir = './images/';
addpath ../../util; %for semistd

data_names = { 'citeseer', 'cora', 'senate', 'usps3nn', 'usps10nn', ...
         'amazon', 'dblp', 'lj', 'youtube'};
         %, 'friendster', 'lj', 'orkut', 'youtube' };
use_names = { 'cite', 'cora', 'sen', 'us3', 'us10', ...
         'amaz', 'dblp', 'lj', 'yout'};
         %, 'friend', 'lj', 'ork', 'yout' };

alg_tags = {'ppr','ppr-d','2','3','4'};
alg_names = {'PPR','PPR-d','2walk','3walk','4walk'};

plot_title = 'Subgraph extraction';
plot_name = 'subg-extract';

%%
% subg_stats =
%     precisions: [9x5 double]
%        recalls: [9x5 double]
%            F1s: [9x5 double]
%     subg_sizes: [9x5 double]
%     comm_sizes: [9x5 double]
%     times: [9x5 double]
%  1-coord is which_comm, 2-coord is: [mean, median, std, max, min];
%

% dataset, which alg, (mean, lb, and ub)
STAT_NAMES = {'recall', 'precision', 'F1', 'cluster-sizes', 'runtimes' };
num_stats = length(STAT_NAMES);
all_subg_values = zeros( num_stats, length(data_names), length(alg_tags), 3);

for dat=1:length(data_names),
    dat_name = data_names{dat};
    for alg_num=1:length(alg_tags),
        alg_name = alg_tags{alg_num};

        load( [load_dir,'subg-', alg_name, '-', dat_name, '.mat'] );

        which_stat = 1;
        stat_type = subg_stats.recalls ;
        stat_vals = stat_type(:,1);
        all_subg_values(which_stat,dat,alg_num,1) = mean( stat_vals );
        [lb, ub] = semistd( stat_vals );
        all_subg_values(which_stat,dat,alg_num,2) = lb;
        all_subg_values(which_stat,dat,alg_num,3) = ub;

        which_stat = 2;
        stat_type = subg_stats.precisions ;
        stat_vals = stat_type(:,1);
        all_subg_values(which_stat,dat,alg_num,1) = mean( stat_vals );
        [lb, ub] = semistd( stat_vals );
        all_subg_values(which_stat,dat,alg_num,2) = lb;
        all_subg_values(which_stat,dat,alg_num,3) = ub;

        which_stat = 3;
        stat_type = subg_stats.F1s ;
        stat_vals = stat_type(:,1);
        all_subg_values(which_stat,dat,alg_num,1) = mean( stat_vals );
        [lb, ub] = semistd( stat_vals );
        all_subg_values(which_stat,dat,alg_num,2) = lb;
        all_subg_values(which_stat,dat,alg_num,3) = ub;

        which_stat = 4;
        stat_type = subg_stats.subg_sizes ;
        stat_vals = stat_type(:,1);
        inds = find( stat_vals >= 3000 );
        stat_vals(inds) = 3000;
        all_subg_values(which_stat,dat,alg_num,1) = mean( stat_vals );
        [lb, ub] = semistd( stat_vals );
        all_subg_values(which_stat,dat,alg_num,2) = lb;
        all_subg_values(which_stat,dat,alg_num,3) = ub;

        which_stat = 5;
        stat_type = subg_stats.times ;
        stat_vals = stat_type(:,1);
        all_subg_values(which_stat,dat,alg_num,1) = mean( stat_vals );
        [lb, ub] = semistd( stat_vals );
        all_subg_values(which_stat,dat,alg_num,2) = lb;
        all_subg_values(which_stat,dat,alg_num,3) = ub;

    end
end
fprintf('\nDone loading.\n');


%%
%%%  Plotting recall, F1, precision, runtimes of extracted subgraphs.
%%%
for which_stat=1:length(STAT_NAMES),
    clf
    stat_name = STAT_NAMES{which_stat};
    sample_stat = squeeze(all_subg_values(which_stat,:,:,1));
    stat_Lbound = squeeze(all_subg_values(which_stat,:,:,2));
    stat_Ubound = squeeze(all_subg_values(which_stat,:,:,3));
    %[1 4 8; 2 5 9; 3 6 10];
    h = bar(sample_stat);
    set(h,'BarWidth',1);    % The bars will now touch each other
    set(gca,'YGrid','on')
    set(gca,'GridLineStyle','-')
    set(gca,'XTicklabel',use_names)
    ylabel(stat_name);
    % set(get(gca,'YLabel'),'String','U')
    lh = legend(alg_names);
    set(lh,'Location','BestOutside','Orientation','horizontal')
    hold on;
    numgroups = size(sample_stat, 1);
    numbars = size(sample_stat, 2);
    groupwidth = min(0.8, numbars/(numbars+1.5));
    for i = 1:numbars
          % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
          x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);
          % Aligning error bar with individual bar
          errorbar(x, sample_stat(:,i), stat_Lbound(:,i), stat_Ubound(:,i), 'k.');
    end

    if strcmp( stat_name, 'runtimes' ),
      set(gca,'yscale','log');
    end
    if which_stat == 1,
      title(plot_title);
    end
    set_figure_size([6,2]);
    xlim( [0.5 length(use_names)+0.5] );
    print(gcf,[ image_dir, plot_name, '-', stat_name, '.png'],'-dpng');

end
