function [topk_stats] = diffusion_aug_experiment( A, C, varargin )
% [topk_stats] = diffusion_aug_experiment( A, C, varargin )
%
% INPUTS
%     A         - adjacency matrix
%     C         - community matrix
%
% varargin:
%   'diffusion'     -- input 'ppr' to use personalized PageRank, 'hk' for the
%                      heat kernel, or an integer k>=1 to use a k-walk;
%                       default = 2
%
% OUTPUTS
%   topk_stats       - struct containing:
%       .precisions  - NUM_COMMS x 3 x 5, where each 3x5 block has rows
%                      corresponding to top-1, -2, -3 augmented seeds, and
%                      the columns correspond to mean, median, std, max, min
%       .times       - NUM_COMMS x 1, where each entry is the total time for that community
%       .comm_sizes  - NUM_COMMS x 1, where each entry is the community's size
%

p = inputParser;
p.addOptional('diffusion', 2);
p.parse(varargin{:});

n = size(A,1);
method = p.Results.diffusion;

NUM_COMMS = size(C,2);

% INITIALIZE
topk_stats.precisions = zeros( NUM_COMMS, 3, 5 );
topk_stats.times = zeros( NUM_COMMS, 1 );
topk_stats.comm_sizes = zeros( NUM_COMMS, 1 );

fprintf('\n Beginning Diffusion seed aug trials\n');

for which_comm=1:NUM_COMMS,

    % Get COMM info
    comm_inds = find( C(:,which_comm) );
    comm_size = length( comm_inds );
    fprintf('\n community %d out of %d ;  num_seeds=%d\n', which_comm, NUM_COMMS, comm_size );

    % initialize variables
    this_topk_prec = zeros( comm_size,3);

    tic;
    for which_seed=1:comm_size,  % COMPUTE ON EACH SEED
        seed = comm_inds(which_seed);

        % CALL ALGORITHM HERE
        new_seedset = diffusion_seed_aug(A, seed,'method', method );
        new_seedset = setdiff( new_seedset, seed, 'stable'); % remove the seed
        for which_topk=1:3,
            if which_topk > length(new_seedset), break; end
            [prec_k, ~] = acc_stats( comm_inds, new_seedset(1:which_topk) );
            this_topk_prec(which_seed,which_topk) = prec_k;
        end
    end
    timet = toc; fprintf('\n \t done in %f \n', timet);

    % TOPK STATS
    this_data = this_topk_prec;
    new_vals = [mean(this_data)', median(this_data)', std(this_data)', max(this_data)', min(this_data)'];
    topk_stats.precisions(which_comm,:,:) = new_vals;
    topk_stats.times(which_comm) = timet;
    topk_stats.comm_sizes(which_comm) = comm_size;
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
