%%%
%%%
% This script displays the performance of the comm-detection algorithms
% with and without subg-extraction: HK, PPR, MOV

clear; clc;
load_dir = '../results/';
image_dir = '../images/';
addpath ../../../util; %for semistd, set_figure_size

%%
% clus_stats =
%      precisions: {NUM_COMMSx1 cell}
%         recalls: {NUM_COMMSx1 cell}
%             F1s: {NUM_COMMSx1 cell}
%        jaccards: {NUM_COMMSx1 cell}
%    conductances: {NUM_COMMSx1 cell}
%           sizes: {NUM_COMMSx1 cell}
%        runtimes: {NUM_COMMSx1 cell}
%
% Each cell entry is an array containing the given statistic for each seed in that community

stat_names = {'precisions', 'recalls', 'F1s', 'jaccards', 'conductances', 'sizes', 'runtimes' };

  %%% FIRST ON SMALL DATASETS
  data_names = {'citeseer', 'cora', 'senate', 'usps3nn', 'usps10nn'};
  use_names = {'cite', 'cora', 'sen', 'us3', 'us10'};
  alg_names = {'HK', 'HKs', 'PPR', 'PPRs', 'MOV', 'MOVs'};
  alg_tags = {'HK', 'HK-subg', 'PPR', 'PPR-subg', 'MOV', 'MOV-subg'};
  plot_name = 'gtc-baseline-vs-subg-small';
  plot_title = sprintf('Effect of subgraph-extraction') ;

  all_values = get_all_values(data_names, alg_tags, stat_names, load_dir );
  fprintf('\nDone loading.\nNow plotting stats.\n');
  make_plots(all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name);

  plot_name = 'gtc-baseline-vs-subg-small-SEEDS';
  plot_title = sprintf('Effect of subgraph-extraction') ;

  all_values = get_all_values_seedwise(data_names, alg_tags, stat_names, load_dir );
  fprintf('\nDone loading.\nNow plotting stats.\n');
  make_plots(all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name);




  %%% NOW FOR BROADER SET OF DATASETS
  data_names = {'citeseer', 'cora', 'senate', 'usps3nn', 'usps10nn', ...
     'amazon', 'dblp', 'friendster', 'lj', 'orkut', 'youtube'};
  use_names = {'cite', 'cora', 'sen', 'us3', 'us10', ...
       'am', 'db', 'fri', 'lj', 'ork', 'you'};
  alg_names = {'HK', 'HKs', 'PPR', 'PPRs'};
  alg_tags = {'HK', 'HK-subg', 'PPR', 'PPR-subg'};
  plot_name = 'gtc-baseline-vs-subg';
  plot_title = sprintf('Effect of subgraph-extraction') ;

  all_values = get_all_values(data_names, alg_tags, stat_names, load_dir );
  fprintf('\nDone loading.\nNow plotting stats.\n');
  make_plots(all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name);



%  plot_name = 'gtc-baseline-vs-subg-SEEDS';
%  plot_title = sprintf('Effect of subgraph-extraction') ;

%  all_values = get_all_values_seedwise(data_names, alg_tags, stat_names, load_dir );
%  fprintf('\nDone loading.\nNow plotting stats.\n');
%  make_plots(all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name);
