function [C_rand_inds, comm_stats] = rand_select_gtcs( A, C, NUM_SUBSET_COMMS )
% [C_rand_inds, comm_stats] = rand_select_gtcs( A, C, NUM_SUBSET_COMMS )
%
% Extract a subset of the communities, uniformly at random and without replacement.
% Then record the community statistics for the chosen ground truth communities.
%
% MIN_COMM_SIZE = 10;

addpath ../../util

% [1] Get subset of communities, unif random no replacement.
n = size(A,1);
degs = full(sum(A,1));
MIN_COMM_SIZE = 10;

comm_sizes = full( sum(C,1) );
big_comm_inds = find( comm_sizes >= MIN_COMM_SIZE );
temp_num_com = length(big_comm_inds);

C = C(:, big_comm_inds);

temp_num_comms = size(C,2);
temp_rand_vec = randn( temp_num_comms, 1 );
[~, rand_inds] = sort( temp_rand_vec );

NUM_SUBSET_COMMS = min( NUM_SUBSET_COMMS, temp_num_comms);

rand_comm_inds = rand_inds(1:NUM_SUBSET_COMMS);
C_rand = C(:,rand_comm_inds);
C_rand_inds = big_comm_inds(rand_comm_inds);

num_comms = size(C_rand, 2);

comm_stats = struct;
comm_stats.sizes = zeros( num_comms, 1 );
comm_stats.edges = zeros( num_comms, 1 );
comm_stats.diameters = zeros( num_comms, 1 );
comm_stats.ave_within = zeros( num_comms, 1 );
comm_stats.conductances = zeros( num_comms, 1 );

for j=1:num_comms,
    fprintf('\n %i', j);
    inds = find(C_rand(:,j));
    Asub = A(inds,inds);
    n_sub = size(Asub,1);
    d_sub = full(sum(Asub,1));
    d_full = degs(inds);

    comm_stats.ave_within(j) = mean(d_sub./d_full);

    comm_stats.sizes(j) = n_sub;
    comm_stats.edges(j) = nnz(Asub)/2;

    distances = graphallshortestpaths(Asub);
    [~,~,vals] = find(distances);
    if length(vals) ~= 0, % in case the community is empty
        comm_stats.diameters(j) = max( vals );
    end

    comm_stats.conductances(j) = cut_cond(A, inds);
end

comm_stats.ave_degs = 2.*comm_stats.edges./comm_stats.sizes;
