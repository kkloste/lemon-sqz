function [time_hk cond_hk bestset_hk hkvec setup_time] = test_hkgrow_mex(filename,tol,alphat,debugflag)
% [times conductances cut_sets hkvec setup_time] = test_hkgrow_mex(filename,tol,alphat,debugflag)
% set debugflag to 1 to turn on messages in the matlab and mex code.
%
% This just checks the files are running and that the mex was compiled
% correctly.
%
% Adapted from "Heat Kernel Based Community Detection"
% [ Gleich & Kloster 2014 ]

fprintf('\n starting hkgrow_mex test \n');

% check inputs
if nargin < 1, filename = 'senate_ccs'; end
if nargin < 2, tol  = 1e-5; end
if nargin < 3, alphat = 1; end
if nargin < 4, debugflag = 0; end

assert(tol > 0 && tol <= 1, 'tol violates 0<tol<=1');
assert(alphat>0, 'alphat violates alphat>0');

load(['./data/' filename]);

d = sum(A,2);
P = colnormout(A);
eP = expm( alphat.*P )./exp(alphat);
n = size(A,1);

for j=1:n

    [dummy cond_hk cut_hk vol_hk hkvec npushes] = hkgrow_mex(A,j,alphat, tol, debugflag);
    hk_error =  norm( hkvec./exp(alphat) - eP(:,j)./d,'inf' );
    assert( hk_error <= tol, sprintf('hkgrow_mex test error on node %i , tol = %f ; error = %f', j, tol, hk_error ) );

end

fprintf('\n hkgrow_mex test cleared! \n');
