% Testing prvec for computing approximate pagerank vectors

fprintf('\n starting prvec_mex test \n');

load ./data/senate_ccs;

n = size(A,1);

epsil = 1e-4;
d = full(sum(A,2));
P = colnormout(A);
alpha = 0.9;

M = (speye(n) - alpha.*P);
for seed = 1:n,
  pr_temp = pprvec_mex( A, seed, epsil, alpha );
  pr = sparse( pr_temp(:,1), 1, pr_temp(:,2), n, 1);

  x = (1-alpha).*(M\sparse(seed,1,1,n,1) );
  assert(  norm( (pr - x)./d, 'inf') <= epsil , ...
  sprintf('prvec_mex test error on node %i , alpha = %f ; error = %f', seed, alpha,  norm( (pr - x)./d, 'inf') ) );
end

fprintf( '\n prvec_mex  test cleared! \n')
