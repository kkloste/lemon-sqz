% Demonstrate that the function local_fiedler.m produces a vector
% satisfying all the constraints it is supposed to.
%
% This method first described in
% [ Mahoney, Orecchia, Vishnoi 2012 ] "A local spectral method for graphs"

fprintf('\n starting MOVgrow test \n');

load('./data/senate_ccs');

n = size(A,1);
d = full(sum(A,2));
L = spdiags(d,0,n,n) - A;

% Set up parameterss = randi(n,5,1);
S = randi(n,5,1); % get seeds
kappa = 0.5;

% Get Fiedler eigenvalue
% because it serves as one end-point of the interval from which the
% parameter gamma will be located.
% (The other endpoint is -vol(G).)
[V, lams] = eigs(L, spdiags(d, 0, n, n), 2, 'SA');
lams = diag(lams);
lambda2 = lams(2);

[V, lams] = eigs(A, spdiags(d, 0, n, n), 2, 'LA');
lams = diag(lams);
lambda22 = 1-lams(2);
fprintf('Are our methods of computing lambda2 the same? Should be near 0.0:  %f \n', abs(lambda2 - lambda22) );

%% Compute MOV
tic;
[output_cluster, x, approx_kappa, gamma, v] = MOVgrow(A, S, 'degrees', d, 'lambda2', lambda2, 'verbose', false ) ;
fprintf('First run done. Run a second time to check varargin. \n' );
[output_cluster2, x2, approx_kappa2, gamma2, v2] = MOVgrow(A, S ) ;
fprintf('Difference between vectors with and without varargin: %f \n', norm(x - x2) );
time_old = toc;

% Check that the result satisfies constraints
fprintf('\ntime_MOV = %f\n', time_old');
fprintf('\nsqrt(kappa) = %f', sqrt(kappa));
fprintf('\n(x^T*D*s) = %f \t(should be >=, close to sqrt(kappa) )', (x.*d)'*v);
fprintf('\ns^T*D*1 = %f \t(should be 0)', v'*d);
fprintf('\n(x^T*D*1) = %f \t(should be 0)',  (x'*d));
fprintf('\n(x^T*D*x) = %f \t(should be 1)',  (x.*d)'*x);
% fprintf('\n(x^T*L*x) = %f ',  (x'*L*x) );
fprintf('\nlambda2 = %f',  lambda2 );
fprintf('\ngamma = %f \t(should be <= lambda2) ',  gamma );

%% Compare to PageRank-like vector
% described in David Gleich's "PageRank Beyond the Web".
alpha = 1/(1-gamma);
f = d.*v;
M = speye(n) - alpha.*(A*spdiags( 1./d, 0, n,n) );
z = M\f;
% scale z so its norm is the same as x
dx = d.*x;
z = z.*( norm(dx)/norm(z) );

fprintf('\n||D*x - z|| = %f \t(should be very near 0)\n', norm(dx-z) );

fprintf('\n MOVgrow test cleared! \n');
