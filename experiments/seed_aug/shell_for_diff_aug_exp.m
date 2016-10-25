function shell_for_diff_aug_exp(fname, varargin)
% function shell_for_diff_aug_exp(fname, varargin)
%
% INPUTS
%   fname     -- name of file to load
%
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

fprintf('\nStarting diff aug on %s \n', fname);
tic;
load( [load_dir, fname, fsuffix, '.mat'] );
fprintf('Done loading %s,  time = %f \n', fname, toc);

n = size(A,1);
comm_sizes = sum(C,1);
MIN_COMM_SIZE = 10;
inds = find(comm_sizes >= MIN_COMM_SIZE);
C = C(:,inds);

methods = { 2, 3, 4, 'ppr', 'hk'};
	for j=1:numel( methods ),
		tic;
		which_diff = methods{j};
		if isnumeric(which_diff), ALG_NAME = num2str(which_diff);
		else ALG_NAME = which_diff;
		end

		[topk_stats] = diffusion_aug_experiment( A, C , 'diffusion', which_diff );
		save( [ save_dir, 'diff-aug-', ALG_NAME, '-', fname, '.mat'], 'ALG_NAME', ...
	    'MIN_COMM_SIZE', 'fname', 'topk_stats', '-v7.3');
		timet = toc;
	    fprintf('Data %s  done on method %d / %d   in time  %f \n', fname, j, numel(methods), timet );
	end

end
