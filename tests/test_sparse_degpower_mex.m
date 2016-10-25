% TEST sparse_degpower_mex.cpp
% Call from /  , not from /tests

fprintf('\n Starting sparse_degpower_mex\n');

load ./data/senate_ccs.mat;

degs = full(sum(A,2));
n = size(A,1);

power = -0.5;
NUM_COMM = size(C,2);
for which_comm = 1:NUM_COMM,
  vec = C(:,which_comm);
  x = sparse_degpower_mex(A, vec, power);
  x_true = vec .* (degs.^power);
  x = sparse(x(:,1), 1, x(:,2), n, 1);
  assert( norm(x - x_true) < eps, sprintf('error on node %i', which_comm) );
end

fprintf('\n sparse_degpower_mex   test cleared!\n');
