function [A, C] = data_ccs_locator(A, C)
%  graph_output = data_ccs_locator(A, C)

n = size(A,1);
addpath ../util;

[S, node_labels] = graphconncomp(A);

nodes_in_LCC = find( node_labels == 1 );

A = A(nodes_in_LCC, nodes_in_LCC);

temp_vec = zeros(n,1);
temp_vec(nodes_in_LCC) = 1;

comms_in_LCC = find( temp_vec'*C );

C = C(nodes_in_LCC, comms_in_LCC);


for j=1:size(C,2),
	this_comm = find(C(:,j));
	comm = A(this_comm, this_comm);
	[S] = graphconncomp(comm);
	assert( length(S) == 1, sprintf('Num conn comp in %i is %i\n', j, length(S))  );
end




