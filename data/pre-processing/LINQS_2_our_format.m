% Convert .txt file containing edge list
% to a .mat file containing a matlab sparse adjacency matrix

clear; clc;
%filename = 'cora';
%filename = 'citeseer';
filename = 'flickr';

tic;
inputA = load([filename, '-adj.txt']);
rows = inputA(:,1);
cols = inputA(:,2);
toc

n = max( max(rows), max(cols) ); % size of the graph is n, the largest label of all node labels.
A = sparse( rows, cols, 1, n, n );
A = A|A';
A = A-spdiags(diag(A),0,n,n);

% Now remove any isolated nodes
d = full(sum(A,2));
node_indices = find(d);
A = A(node_indices, node_indices);

 %%

save([filename, '-adj.mat'], 'A', '-v7.3');

%% NOW DO COMMUNITY

inputC = load([filename, '-comm.txt']);
rows = inputC(:,1);
cols = inputC(:,2);

num_comm = max( max(rows) );
% size of the graph is n, the largest label of all node labels.

C = sparse( rows, cols, 1, num_comm, n );
C = spones(C);

C = C(:, node_indices); % remove isolated nodes from the community matrix
% Also ensures node labels in C match node labels in A.

comm_population = full(sum(C,2));
inds = find(comm_population);
C = C(inds,:); %remove empty communities.
comm_population = comm_population(inds);
[vals, perm] = sort(comm_population, 'ascend');
C = C(perm,:); % reorder so that smallest community is top row,
% and largest community is bottom row.

save([filename, '-comm.mat'], 'C', '-v7.3');


