% Convert .txt file containing edge list
% to a .mat file containing a matlab sparse adjacency matrix

load facebook_combined.txt;
rows = facebook_combined(:,1)+1; % shift so indices begin from 1, not 0
cols = facebook_combined(:,2)+1;

n = max( max(rows), max(cols) );
% size of the graph is n, the largest label of all node labels.

A = sparse( rows, cols, 1, n, n );