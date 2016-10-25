function new_seedset = diffusion_seed_aug( A, seed_set, varargin )
% new_seed_set = diffusion_seed_aug( A, seed_set, varargin )
%
% INPUTS
%   A                   - adjacency matrix
%   seed_set            - small set of nodes
%
% varargin:
%   'method'          -- which diffusion to use: 'hk', 'ppr', or integer (for walk-length)
%                         default = 'ppr'
%   'num_new_seeds'   -- number of new seeds; default = 3
%   'deg_scale'       -- scale diffusion vector by node degrees before sorting; default = true
%
% OUTPUTS
%   new_seedset       - new seed set, from a diffusion on a subgraph

p = inputParser;
p.addOptional('method', 'ppr');
p.addOptional('num_new_seeds', 3, @isnumeric);
p.addOptional('deg_scale', true, @islogical);
p.parse(varargin{:});

num_new_seeds = p.Results.num_new_seeds;
method = p.Results.method;
if isnumeric(method);
  method_name = 'walk';
  walk_length = method;
else
  method_name = method;
end


% [1] COMPUTE DIFFUSION
epsil = 1e-4;
alpha = 0.99;
hkt =   log( 1/(1-alpha) )/log(exp(1)) ;
n = size(A,1);

switch method_name
  case 'ppr'
    temp = pprvec_mex(A, seed_set, epsil, alpha);
    inds = temp(:,1);
    vals = temp(:,2);

  case 'hk'
    temp = hkvec_mex(A, seed_set, hkt, epsil );
    inds = temp(:,1);
    vals = temp(:,2);

  case 'walk'
    temp = sparse_k_walk( A, seed_set, walk_length );
    [inds, ~, vals] = find(temp);

end


% [2] SORT BY DIFFUSION
if p.Results.deg_scale == true,
  temp_vec = sparse( inds, 1, vals, n, 1 );
  temp_vec = sparse_degpower_mex(A, temp_vec, -1.0);
  inds = temp_vec(:,1);
  vals = temp_vec(:,2);
end
[~, permut] = sort(vals,'descend');
sorted_inds = inds( permut(1:min(num_new_seeds + length(seed_set), length(permut))) );
sorted_inds = setdiff( sorted_inds, seed_set, 'stable');

new_seedset = sorted_inds( 1: min(num_new_seeds, length(sorted_inds)) );
