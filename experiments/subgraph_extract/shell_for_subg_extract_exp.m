function shell_for_subg_extrac_exp(fname, which_method, varargin)
% function shell_for_subg_extrac_exp(fname, varargin)
%
% INPUTS
%   fname     			-- name of file to load
%		which_method		--  which method, 1:5, [ 2, 3, 4, hk, ppr]
% varargin:
%   'load_dir'    -- path, relative to current dir, to dataset, default='../../data/'
%   'fsuffix'     -- use if data's filename has something at end of "fname"

% PARAMETERS
p = inputParser;
p.addOptional('load_dir', '../../data/');
p.addOptional('fsuffix', '');
p.parse(varargin{:});

load_dir = p.Results.load_dir;
fsuffix = p.Results.fsuffix;

addpath ../.. ;               % for diff codes
addpath ../../util;
addpath ../../baseline_codes; % for diff codes

save_dir = './results/';

fprintf('\nStarting subg extract on %s \n', fname);
tic;
load( [load_dir, fname, fsuffix, '.mat'] );
fprintf('Done loading %s,  time = %f \n', fname, toc);

n = size(A,1);
comm_sizes = sum(C,1);
MIN_COMM_SIZE = 10;
inds = find(comm_sizes >= MIN_COMM_SIZE);
C = C(:,inds);

methods = { 2, 3, 4, 'ppr', 'ppr'};
method_names = { 2, 3, 4, 'ppr', 'ppr-d'};

alpha = 0.99;
epsil = 1e-4;

if which_method == 5,
	ave_deg = nnz(A) / n;
	expected_num_nodes = min( 3000, n/5 );
	expected_volume = ave_deg * expected_num_nodes ;
	temp = 1/(200*expected_volume);
	epsil = temp^(2/3);
	alpha = 1 - temp^(1/3);
end

		tic;
		which_diff = methods{which_method};
		which_name = method_names{which_method};
		if isnumeric(which_diff), ALG_NAME = num2str(which_name);
		else ALG_NAME = which_name;
		end

		[subg_stats] = subg_extract_experiment( A, C , 'diffusion', which_diff, 'alpha', alpha, 'epsil', epsil );
		save( [ save_dir, 'subg-', ALG_NAME, '-', fname, '.mat'], 'ALG_NAME', ...
	    'MIN_COMM_SIZE', 'fname', 'alpha', 'epsil', 'subg_stats', '-v7.3');
		timet = toc;
	    fprintf('Data %s  done on method %d / %d   in time  %f \n', fname, j, numel(methods), timet );


end
