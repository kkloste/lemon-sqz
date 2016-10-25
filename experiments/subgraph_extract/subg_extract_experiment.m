function [subg_stats] = subg_extract_experiment( A, C, varargin )
% [subg_stats] = subg_extract_experiment( A, C, varargin )
%
% INPUTS
%     A         - adjacency matrix
%     C         - community matrix
%
% varargin:
%   'diffusion'     -- input 'ppr' to use personalized PageRank, 'hk' for the
%                      heat kernel, or an integer k>=1 to use a k-walk;
%                       default = 2
%   'alpha'       -- ppr (alpha) / hk (t) parameter; default 0.99
%   'epsil'       -- accuracy used in ppr/hk, default 1e-4
%
% OUTPUTS
%   subg_stats       - struct containing:
%       .precisions  - NUM_COMMS  x 5, where each row gives [ mean, median, std, min, max]
%                       precision for that community
%       .recalls     - NUM_COMMS  x 5, where each row gives [ mean, median, std, min, max]
%                       recall for that community
%       .F1s         - NUM_COMMS  x 5, where each row gives [ mean, median, std, min, max]
%                       F1 for that community
%       .subg_sizes  - NUM_COMMS  x 5, where each row gives [ mean, median, std, min, max]
%                       of the subgraph sizes for that community
%       .times       - NUM_COMMS  x 5, where each row gives [ mean, median, std, min, max]
%                       of the runtimes for that community
%       .comm_sizes  - NUM_COMMS x 1, where each entry is the community's size
%

p = inputParser;
p.addOptional('diffusion', 2);
p.addOptional('alpha', 0.99);
p.addOptional('epsil', 1e-4);
p.parse(varargin{:});

n = size(A,1);
method = p.Results.diffusion;
alpha = p.Results.alpha;
epsil = p.Results.epsil;

NUM_COMMS = size(C,2);

% INITIALIZE
subg_stats.precisions = zeros( NUM_COMMS, 5 );
subg_stats.recalls = zeros( NUM_COMMS, 5 );
subg_stats.F1s = zeros( NUM_COMMS, 5 );
subg_stats.subg_sizes = zeros( NUM_COMMS, 5 );
subg_stats.times = zeros( NUM_COMMS, 5 );
subg_stats.comm_sizes = zeros( NUM_COMMS, 1 );

fprintf('\n Beginning Diffusion seed aug trials\n');

for which_comm=1:NUM_COMMS,

    % Get COMM info
    comm_inds = find( C(:,which_comm) );
    comm_size = length( comm_inds );
    fprintf('\n community %d out of %d ;  num_seeds=%d\n', which_comm, NUM_COMMS, comm_size );

    % initialize variables
    this_prec = zeros( comm_size, 1);
    this_rec = zeros( comm_size, 1);
    this_f1 = zeros( comm_size, 1);
    this_subg_size = zeros( comm_size, 1);
    this_time = zeros( comm_size, 1);

    for which_seed=1:comm_size,  % COMPUTE ON EACH SEED
        seed = comm_inds(which_seed);

        % CALL ALGORITHM HERE
        tic;
        subg = subgraph_extraction( A, seed, 'method', method, 'epsil', epsil, 'alpha', alpha );
        this_time(which_seed) = toc;
        [this_prec(which_seed), this_rec(which_seed), this_f1(which_seed)] = acc_stats( comm_inds, subg );
        this_subg_size(which_seed) = length(subg);

    end

    % RECORD STATS
    subg_stats.precisions(which_comm,:) = get_stat_row( this_prec );
    subg_stats.recalls(which_comm,:) = get_stat_row( this_rec );
    subg_stats.F1s(which_comm,:) = get_stat_row( this_f1 );
    subg_stats.subg_sizes(which_comm,:) = get_stat_row( this_subg_size );
    subg_stats.times(which_comm,:) = get_stat_row( this_time );

    subg_stats.comm_sizes(which_comm) = comm_size;
    fprintf('\t Done in %f \n', sum(this_time) );
end

end % END OUTER FUNCTION


function [precision, recall, F1] = acc_stats( true_set, guess_set )
    size_intersection = numel(intersect(true_set, guess_set));
    guess_set_size = numel(guess_set);
    precision = 0;
    if guess_set_size ~= 0, precision =  size_intersection / guess_set_size; end
    true_set_size = numel(true_set);
    recall = 0;
    if true_set_size ~= 0, recall = size_intersection / true_set_size; end
    F1 = 0;
    if (precision+recall) ~= 0, F1 = 2*recall*precision/( recall + precision); end
end

function new_vals = get_stat_row( this_data )
    new_vals = [mean(this_data), median(this_data), std(this_data), max(this_data), min(this_data)];
end
