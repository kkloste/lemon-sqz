clear; clc;
load_dir = './results/';
image_dir = './images/';

data_names = {'citeseer', 'cora', 'senate', 'usps3nn', ...
  'usps10nn', 'amazon', 'dblp', 'youtube', 'lj'};

prefix = 'diff-aug';
alg_tags = {'2', '3', '4', 'hk', 'ppr'};

%%
% topk_stats =
%     precisions: [9x3x4 double]
%
%     topk_stats.precisions(which_comm,:,:) = [mean', median', std', max', min'];
%
%   each row of this matrix corresponds to top-k for k=1,2,3
%
% topk_stats =
%    comm_sizes
%    precisions
%    times

all_values = zeros( length(data_names), length(alg_tags), 3, 3);

for which_dat=1:length(data_names),
    dat_name = data_names{which_dat};
    for which_alg=1:length(alg_tags),
        alg_name = alg_tags{which_alg};

        load( [load_dir, prefix, '-', alg_name, '-', dat_name, '.mat'] );

        stat_type = topk_stats.precisions ;
        for which_k=1:size(stat_type,2),
            stat_vals = stat_type(:,which_k,1);
            stat_stds = stat_type(:,which_k,3);
            stat_min = stat_type(:,which_k,5);
            all_values(which_dat,which_alg,which_k,:) = mean( [stat_vals, stat_stds, stat_min] );
        end


    end
end
fprintf('\nDone loading.\n');


%%
%%%
%%%

clc
stat_name = 'GTC Precision';
stat_type =  {'mean', 'std'};
stat_ids = [1,2];

for WHICH_TYPE = 1:length(stat_ids),
    WHICH_STAT = stat_ids(WHICH_TYPE);
    for TOP_K=1:3,

        fprintf('\n %s, %s ,  top-%d \n ', stat_name, stat_type{WHICH_TYPE}, TOP_K );

        for which_dat=1:length(data_names),
            fname = data_names{ which_dat };
            fprintf( '\\texttt{%s}', fname );
            for alg_num=1:length(alg_tags),
                    fprintf(' & %.2f', squeeze( all_values(which_dat,alg_num,TOP_K,WHICH_STAT)) );
            end
            fprintf( ' \\\\ \n' );
        end
    end
end
