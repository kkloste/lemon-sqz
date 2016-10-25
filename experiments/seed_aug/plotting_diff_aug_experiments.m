%%%
%%%
% This script reports the precision of the various seed-set augmentation
% approaches we consider: single diffusions (ppr, hk, 1, 2, 3) i.e. with
% no prior subgraph extraction

clear; clc;
load_dir = './results/';
image_dir = './images/';
addpath ../../util; %for semistd, set_figure_size

data_names = {'citeseer', 'cora', 'senate', 'usps3nn', 'usps10nn', ...
    'amazon', 'dblp', 'lj', 'youtube'};
use_names = {'cite', 'cora', 'sen', 'us3', 'us10', ...
    'amaz', 'dblp', 'lj', 'yout'};
alg_names = {'HK', 'PPR', '2walk', '3walk', '4walk'};
alg_tags = {'hk', 'ppr', '2', '3', '4'};

plot_title = 'Seedset augmentation';
plot_name = 'diff-aug-precision';

prefix = 'diff-aug';

%%
% topk_stats =
%     precisions: [num_comms x 3 x 5 double]
%     topk_stats.precisions(which_comm,:,:) = [mean', median', std', max', min'];
%   each row of this matrix corresponds to top-k for k=1,2,3
%
%    comm_sizes: [num_comms x 1]
%    times: [num_comms x 1]


all_prec_values = zeros( length(data_names), length(alg_tags), 3, 3);
% all_prec_values( which_data, which_alg, which_k, :) =  stats for top-k: [ precision , lb, ub ]
all_time_values = zeros( length(data_names), length(alg_tags), 3);

for which_dat=1:length(data_names),
    dat_name = data_names{which_dat};
    for which_alg=1:length(alg_tags),
        alg_name = alg_tags{which_alg};
        load( [load_dir, prefix, '-', alg_name, '-', dat_name, '.mat'] );
        comm_sizes = topk_stats.comm_sizes;
        stat_type = topk_stats.precisions ;
        for which_k=1:size(stat_type,2),
            stat_vals = stat_type(:,which_k,1);
            [lb, ub] = semistd( stat_vals );
            all_prec_values(which_dat,which_alg,which_k,:) = [ mean(stat_vals), lb, ub ];
        end

        this_time_rel = topk_stats.times./comm_sizes ;
        [lb, ub] = semistd( this_time_rel );
        all_time_values(which_dat,which_alg,:) = [ mean(this_time_rel), lb, ub ];

    end
end
fprintf('\nDone loading.\nNow plotting precision.\n');


%%
%%%  Plotting precision of augmented seed set.
%%%
for which_k=1:size(all_prec_values, 3),
    clf
    sample_stat = squeeze(all_prec_values(:,:,which_k,1));
    stat_Lbound = squeeze(all_prec_values(:,:,which_k,2));
    stat_Ubound = squeeze(all_prec_values(:,:,which_k,3));
    %[1 4 8; 2 5 9; 3 6 10];
    h = bar(sample_stat);
    set(h,'BarWidth',1);    % The bars will now touch each other
    set(gca,'YGrid','on')
    set(gca,'GridLineStyle','-')
    set(gca,'XTicklabel',use_names)
    ylabel('Precision');
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

    title( plot_title );
    set_figure_size([6,2]);
    xlim( [0.5 length(use_names)+0.5] );
    print(gcf,[ image_dir, plot_name, '-top-', num2str(which_k), '.png'],'-dpng');

end

fprintf('\nPrecision plotting done.\nNow plotting times.\n');

%%
%%%  Plotting runtime of seed set augmentation via initial subgraph extraction
%%%
plot_name = 'diff-aug-times';
    clf
    sample_stat = squeeze(all_time_values(:,:,1));
    stat_Lbound = squeeze(all_time_values(:,:,2));
    stat_Ubound = squeeze(all_time_values(:,:,3));
    %[1 4 8; 2 5 9; 3 6 10];
    h = bar(sample_stat);
    set(h,'BarWidth',1);    % The bars will now touch each other
    set(gca,'YGrid','on')
    set(gca,'GridLineStyle','-')
    set(gca,'XTicklabel',use_names)
    ylabel('Runtime');
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

    set(gca,'yscale','log');
    % title( plot_title );
    set_figure_size([6,2]);
    xlim( [0.5 length(use_names)+0.5] );
    print(gcf,[ image_dir, plot_name, '.png'],'-dpng');
