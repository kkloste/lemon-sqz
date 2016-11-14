% get_dataset_properties
%data_names = { 'cora', 'citeseer', 'senate', 'usps-3nn', 'usps-10nn', 'amazon', 'dblp', 'friendster', 'lj', 'orkut', 'youtube' };
data_names = { 'cora', 'citeseer', 'senate', 'usps-3nn', 'usps-10nn', 'amazon', 'dblp', 'friendster', 'lj', 'orkut', 'youtube' };
data_tags = [ 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0];

dataset_stats = zeros( length(data_names), 3 ) ;
comm_stats = zeros( length(data_names), 6 );

% first do small datasets
load_dir = '../data/';
for which_dat=1:length(data_names),
    tic;
    fname = data_names{which_dat};
    full_fname = fname;
    full_load_dir = '../data/data_big/';
    if data_tags(which_dat) == 1,
        full_fname = [fname, '_ccs'];
        full_load_dir = '../data/';
    end
    load([full_load_dir, full_fname, '.mat']);
    dataset_stats(which_dat,1) = size(A,1);
    dataset_stats(which_dat,2) = nnz(A)/2;
    dataset_stats(which_dat,3) = nnz(A) / size(A,1);

    degs = full(sum(A,1));
    % RUN EXPERIMENT
    n = size(C,1);
    comm_sizes = full( sum(C,1) );
    big_comm_inds = find( comm_sizes >= 10 );
    num_comms = length(big_comm_inds);

    comm_stats(which_dat,1) = num_comms;
    C = C(:, big_comm_inds);

    distance_stats.sizes = zeros( num_comms, 1 );
    distance_stats.edges = zeros( num_comms, 1 );
    distance_stats.diameters = zeros( num_comms, 1 );
    distance_stats.ave_within = zeros( num_comms, 1 );

    for j=1:num_comms,
        fprintf('\n %i', j);
        inds = find(C(:,j));
        Asub = A(inds,inds);
        n_sub = size(Asub,1);
        d_sub = full(sum(Asub,1));
        d_full = degs(inds);

        distance_stats.ave_within(j) = mean(d_sub./d_full);

        distance_stats.sizes(j) = n_sub;
        distance_stats.edges(j) = nnz(Asub)/2;

        distances = graphallshortestpaths(Asub);
        [~,~,vals] = find(distances);
        if length(vals) ~= 0, % in case the community is empty
            distance_stats.diameters(j) = max( vals );
        end
    end

    comm_stats(which_dat,2) = mean(distance_stats.sizes) ;
    comm_stats(which_dat,3) = mean(distance_stats.edges);
    comm_stats(which_dat,4) = 2*mean(distance_stats.edges./distance_stats.sizes);
    comm_stats(which_dat,5) = mean(distance_stats.ave_within);
    comm_stats(which_dat,6) = mean(distance_stats.diameters);

    timet=toc; fprintf('done with %s  in  %f \n', fname, timet);
end

data_info.dataset_stats = dataset_stats;
data_info.comm_stats = comm_stats;

save('dataset_stats','data_info','data_names','-v7.3');
