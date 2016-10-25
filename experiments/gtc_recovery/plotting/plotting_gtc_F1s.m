%%%
%%%
% This script reports the F1 score and runtime of the comm-detection algorithms
% we consider: HK, PPR, LEMONoriginal, LEMONsimple, MOV

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

data_names = {'citeseer', 'cora', 'senate', 'usps3nn', 'usps10nn', ...
    'amazon', 'dblp', 'friendster', 'lj', 'orkut', 'youtube'};
use_names = {'cite', 'cora', 'sen', 'us3', 'us10', ...
    'amaz', 'dblp', 'fri', 'lj', 'ork', 'you'};
alg_names = {'HKs', 'PPRs', 'LEMON', 'LEMeasy', 'MOVs'}; % leave out MOV until it is all done
alg_tags = {'HK-subg', 'PPR-subg', 'LEMorig', 'LEMsimple-noauto-fswp', 'MOV-subg'}; % MOV

plot_name = 'gtc-all-algs';
plot_title = 'Community Detection Performance';

all_values = get_all_values(data_names, alg_tags, stat_names, load_dir );
fprintf('\nDone loading.\nNow plotting stats.\n');
make_plots(all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name);

% plot_name = 'gtc-all-algs-SEEDS';
% all_values = get_all_values_seedwise(data_names, alg_tags, stat_names, load_dir );
% fprintf('\nDone loading.\nNow plotting stats.\n');
% make_plots(all_values, use_names, alg_names, plot_title, stat_names, image_dir, plot_name);
