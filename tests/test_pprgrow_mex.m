function test_pprgrow_mex(filename,tol,alphat,debugflag)
% [time_pr cond bestset prvec setup_time] = test_pprgrow_mex(filename,tol,alpha,debugflag)
% set debugflag to 1 to turn on messages in the matlab and mex code.
%
% This just checks the files are running and that the mex was compiled
% correctly.
%
% Call from /  , not from /tests

fprintf('\n starting pprgrow_mex test \n');

% check inputs
if nargin < 1, filename = 'senate_ccs'; end
if nargin < 2, tol  = 1e-4; end
if nargin < 3, alpha = 0.85; end
if nargin < 4, debugflag = 0; end

assert(tol > 0 && tol <= 1, 'tol violates 0<tol<=1');
assert(alpha>0 || 1>alpha, 'alpha violates 1>alpha>0');

load(['./data/' filename]);

curexpand = ceil( (1/tol)/(1-alpha) ); % 1/tol

d = sum(A,2);
P = colnormout(A);
n = size(A,1);
M = (speye(n) - alpha.*P);

for seed=1:n,

    [curset cond cut vol dummy] = pprgrow_mex(A,seed,curexpand,alpha);
    prvec = zeros(n,1);
    prvec(dummy(:,1)) = dummy(:,2);

    x_true = (1-alpha)*(M\sparse(seed,1,1,n,1)) ;
    assert( norm( prvec - x_true./d ,'inf' ) <= tol , ...
      sprintf('pprgrow_mex test error on node %i , tol = %f ; error = %f', seed, tol,  norm( prvec - x_true./d, 'inf') ) );

end

fprintf('\n pprgrow_mex test cleared! \n');
