function shell_for_ALG(fname, varargin)
% function shell_for_ALG(fname, varargin)
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

addpath ../.. ;               % for ppr_vec etc
addpath ../../util;
addpath ../../baseline_codes; % for subgraph_extraction

save_dir = './results/';

fprintf('\nStarting seed aug on %s \n', fname);
tic;
load( [load_dir, fname, fsuffix, '.mat'] );
fprintf('Done loading %s,  time = %f \n', fname, toc);

n = size(A,1);
comm_sizes = sum(C,1);
MIN_COMM_SIZE = 10;
inds = find(comm_sizes >= MIN_COMM_SIZE);
C = C(:,inds);

smeth = [ 1, 2, 3 ];
for j=1:length(smeth),
	tic;
	subg_method = smeth(j);
	ALG_NAME = [ num2str(subg_method), '-ppr' ];

	[topk_stats] = seed_aug_experiment( A, C , 'subg_method', subg_method, 'rank_method', 'ppr');
	save( [ save_dir, 'seed-aug-', ALG_NAME, '-', fname, '.mat'], 'ALG_NAME', ...
    'MIN_COMM_SIZE', 'fname', 'topk_stats', '-v7.3');

	timet = toc;
    fprintf('Data %s  done on method %d    in time  %f \n', fname, j, timet );
end
