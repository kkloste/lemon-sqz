% Must add path to cvx directroy
% then call cvx_setup

clear; clc;
load_dir = '../../data/';
files = dir([load_dir, '*_ccs.mat']);

for j=1:length(files),
    fname = files(j).name;
    analyzing_lemon_coeffs( fname, 100 );
end

% analyzing_lemon_coeffs( 'lj', 1000, '../../data_big/');
% analyzing_lemon_coeffs( 'youtube', 1000, '../../data_big/');
% analyzing_lemon_coeffs( 'dblp', 1000, '../../data_big/');
