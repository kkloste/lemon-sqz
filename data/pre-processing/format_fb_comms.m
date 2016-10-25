% Processing Facebook egonet data
% load NAME.csv
clc; clear;
load ../../fb_adj;
n = size(A,1); % number nodes in the graph

%% Loop over all csv files in directory

files = dir('*.csv');
struct_size = length(files);
FB_comms = cell(struct_size, 1);
FB_seeds = zeros(struct_size, 1);
%%
which_comm = 1;
Crows = [];
Ccols = [];
C = [];
comm_seed = [];

for file = files',
    % get input file
    fname = file.name;
    Ccsv = load(fname);
    X = sparse(Ccsv');
    FB_seeds(which_comm) = str2num(fname(1:end-4))+1; %get seed ID
    
    % convert to sparse matrix
    m = size(X,2); % number of communities ("circles") our seed is in
    rows = [];
    cols = [];
    for j=1:m,
        inds = find(X(:,j));
        rows = [rows; X(inds,j)];
        cols = [cols; j*ones( length(inds),1) ];
    end
    comms = sparse( rows, cols, 1, n, m);
    
    % Check for correctness:
    for j=1:m,
        inds1 = find( comms(:,j) );
        inds2 = X(find(X(:,j)), j);
        assert( 1 == length( intersect(inds1, inds2) ) / length( union(inds1, inds2) ), ...
            sprintf('MISMATCH on j=%d',j) );
    end
    
    FB_comms{which_comm} = comms;
%     Crows = [Crows; rows];
%     Ccols = [Ccols; cols];
    C = [C, comms]; % slow, but easy
    comm_seed = [comm_seed; FB_seeds(which_comm)*ones(m,1) ];
    
    which_comm = which_comm+1;
end

num_comms = length(comm_seed);
%C = sparse( Crows, Ccols, 1, n, num_comms);

%% Check C for correctness:

for j=1:size(C,2),
   inds = find( C(:,j) );
   which_cols = find( comm_seed == comm_seed(j) );
   
   temp_comm = FB_comms{ FB_seeds == comm_seed(j) };
   assert( 0 == norm( C(:,which_cols) - spones(temp_comm), 'fro' ), ...
       sprintf('MISMATCH on j=d%',j) );
end

save('../../fb_comms','C','comm_seed','FB_comms','FB_seeds');
