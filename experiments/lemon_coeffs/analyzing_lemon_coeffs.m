function analyzing_lemon_coeffs( fname, num_trials, load_dir, save_dir )

if nargin < 2, num_trials = 1000; end
if nargin < 3, load_dir = '../../data/'; end
if nargin < 4, save_dir = './results/'; end

addpath ../../; % for diffusion codes
tic;
load( [load_dir, fname] );
n = size(A,1);
d = full(sum(A,2));
d0 = d+ones(n,1); % 
d0insq = spdiags( d0.^(-1/2), 0, n, n );

Abar = d0insq*(A+speye(n))*d0insq;
fprintf('\nDone pre-processing Abar %f', toc);


%% PREPARE EXPERIMENT

which_coeffs = zeros( num_trials, 2, 2, 3 );
coeff_jaccards = zeros( num_trials, 2, 4 );
seeds = randi(n, num_trials, 1);

k = 3;
l = 3;
    
for which_trial=1:num_trials,

    seed = seeds(which_trial);


    [x_old, x_pos, jaccards1] = lemon_coeffs(Abar,seed,k,l);
    which_coeffs( which_trial, 1, 1, : ) = x_old;
    which_coeffs( which_trial, 2, 1, : ) = x_pos;
    coeff_jaccards( which_trial, 1, : ) = jaccards1;
    
    hkv = hkvec_mex(A, seed);
    hk_inds = hkv(:,1);
    hk_vals = hkv(:,2);
    [~,permut] = sort( hk_vals, 'descend');
    set_size = min(10, length(permut));
    S = permut(1:set_size);
    
    [x_old, x_pos, jaccardsS] = lemon_coeffs(Abar,S,k,l);
    which_coeffs( which_trial, 1, 2, : ) = x_old;
    which_coeffs( which_trial, 2, 2, : ) = x_pos;
    coeff_jaccards( which_trial, 2, : ) = jaccardsS;
   
    fprintf('\nDone with trial=%d out of %d', which_trial, num_trials);
end

fprintf('\nDONE: lemon coeffs, %s\n\n', fname);

save( [save_dir, fname, '-lem-coeffs.mat'], 'which_coeffs', 'coeff_jaccards','seeds');