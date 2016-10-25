function [output_cluster, x, approx_kappa, gamma, v] = MOVgrow(A, S, varargin)
% [output_cluster, x, approx_kappa, gamma, v] = MOVgrow(A, S, varargin)
%
% Constructs the "MOV" vector, i.e. a locally-biased version of the Fiedler vector,
% and uses it to identify a local cut near the input seeds S.
%
% INPUTS:
%   A       -  adjacency matrix
%   S       -  seed set
%
% VARARGIN:
%   degrees -  vector of degrees (if not passed as an input,
%              then this function computes them automatically)
%   kappa   -  correlation parameter, 0 < kappa < 1, controls extent to which
%               MOV vector correlates with seed set (1 is maximal).
%               default: 0.75
%   verbose -  set to true to output gamma and x'*L*x at each step.
%   lambda2 -  the smallest positive generalized eigenvalue of the Laplacian
%               (This is the Fiedler eigenvalue)
%              If lambda2 is omitted, this function will compute it automatically via
%              MATLAB's built in eigs command. If this function is going to be called
%              multiple times, some cost can be saved by pre-computing lambda2 a
%              single time and passing it in as a parameter. Compute via
%                [lams] = eigs(A, spdiags(d, 0, n, n), 2, 'LA');
%                lambda2 = 1-lams(2);
%
% OUTPUTS:
%   output_cluster       - good conductance cut identified by sweepcut over MOV vector
%   x                    - locally biased fiedler vector (MOV vector)
%   approx_kappa         - sqrt(x' D v)
%   gamma                - optimal value found to make the solution of y = (L - gamma*D) vd; the desired MOV vector
%   v                    - seed vector normalized in special manner as per MOV paper.
%
% Kyle Kloster, Purdue University 2015
%
% Algorithm first presented in
% Mahoney, Orecchia, Vishnoi "A local spectral method for graphs" JMLR 2012

  p = inputParser;
  p.addOptional('degrees',[0]);
  p.addOptional('kappa',0.5);
  p.addOptional('verbose',false, @islogical);
  p.addOptional('lambda2',0);
  p.parse(varargin{:});


  if p.Results.verbose, fprintf('About to compute local fiedler.\n'); end

  [x, approx_kappa, gamma, v] = local_fiedler(A, S, varargin{:} );

  if p.Results.verbose, fprintf('Done computing MOV vector.\n'); end

  sw_range = [length(S), min(size(A,1), 3000)];
  [output_cluster,bestcond,bestcut,bestvol,noderank] = sweepcut(A,x,'halfvol',true,'sweeprange', sw_range);

end


%%%%
%%    FUNCTION DEFS
%%%%

function [x, approx_kappa, gamma, v] = local_fiedler(A, S, varargin)
  % SETUP PARAMETERS
  p = inputParser;
  p.addOptional('degrees',[0]);
  p.addOptional('kappa',0.5);
  p.addOptional('verbose',false, @islogical);
  p.addOptional('lambda2',0);
  p.parse(varargin{:});

  verbose = p.Results.verbose;
  if verbose, fprintf('\t localfiedler() parameters retrieved.\n'); end

  n = size(A,2);
  d = p.Results.degrees;
  if length(d) ~= n, d = full(sum(A,2)); end
  kappa = p.Results.kappa;
  lambda2 = p.Results.lambda2;
  if lambda2 == 0,
    [lams] = eigs(A, spdiags(d, 0, n, n), 2, 'LA');
    lambda2 = 1 - lams(2);
  end

  volG = sum(d);
  volS = sum(d(S));
  volSbar = volG - volS;
  temp_scalar = sqrt( volS*volSbar/volG );
  v = -(temp_scalar/volSbar).*ones(n,1);
  v(S) = temp_scalar/volS;
  % dsq = d.^(1/2);
  Dsq = spdiags( d.^(1/2), 0, n, n) ;

  vd = v.*d;
  sqkappa = sqrt(kappa);

  gamma_left = -volG;
  gamma_right = lambda2;
  gamma_cur = (gamma_left + gamma_right)/2;
  gamma = [];
  kappa_tol = 1e-2;
  approx_kappa = -1;

  if verbose, fprintf('\t localfiedler(), about to binary search for gamma.\n'); end

  % BINARY SEARCH FOR GAMMA
  iter_max = 200;
  cur_iter = 0;
  while ( abs(approx_kappa - sqkappa) > kappa_tol || approx_kappa < sqkappa ),
      cur_iter = cur_iter + 1;
      gamma = gamma_cur;
      x = MOV_for_gamma(A, gamma, d, vd);

      approx_kappa = x'*vd;
      if approx_kappa > sqkappa,
          gamma_left = gamma_cur;
      else
          gamma_right = gamma_cur;
      end
      gamma_cur = (gamma_left + gamma_right)/2;
      if verbose, fprintf(' %d : gamma_cur=%f   x^TLx = %f \n ', cur_iter, gamma_cur, x'*Dsq*Dsq*x - x'*A*x); end
      if cur_iter >= iter_max, break; end
  end
end

function y = MOV_for_gamma(A, gamma, d, vd)
  n = size(A,1);
  y = (A + spdiags( (gamma-1).*d, 0, n, n) )\vd;
  y = y./( -sqrt(d'*(y.*y)) ); % normalize
end
