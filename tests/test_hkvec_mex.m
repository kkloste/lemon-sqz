% Testing hkvec
% Call from /  , not from /tests

fprintf('\n starting hkvec_mex test \n');

load ./data/senate_ccs;

n = size(A,1);
t = 3;
epsil = 1e-4;
d = full(sum(A,2));
P = colnormout(A);

eP = expm( t.*P );

for seed = 1:n,
  hk_temp = hkvec_mex( A, seed, t, epsil );
  hk = sparse( hk_temp(:,1), 1, hk_temp(:,2), n, 1);
  x = eP(:,seed);

  assert(  norm( (hk - x)./d, 'inf')/exp(t) <= epsil , sprintf('hkvec_mex test error on node %i , t = %i', seed, t) );
end

fprintf( '\n hkvec_mex  test cleared! \n')
