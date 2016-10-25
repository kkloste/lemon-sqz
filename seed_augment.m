function [new_seedset, temp_subgraph, subgraph_ranking] = seed_augment(A, seed_set, varargin)
% [new_seedset, temp_subgraph, subgraph_ranking] = seed_augment(A, seed_set, varargin)
% INPUTS
%   A                   - adjacency matrix
%   seed_set            - small set of nodes
%
% varargin:
%   'num_new_seeds'   -- number of new seeds; default value 3
%   'subgraph_size'   -- size of subgraph to extract; default value 500
%                        use 0 to skip subgraph extraction step
%   'subg_method'     -- input 'ppr' to use personalized PageRank,
%                         or an integer k>=1 to use a k-walk; default 'ppr'
%   'rank_method'     -- input 'ppr' to use personalized PageRank,
%                         or an integer k>=1 to use a k-walk; default 'ppr'
%
%   'alpha'           -- teleportation constant used in ppr; default 0.99
%   'epsil'           -- accuracy used in ppr; default 1e-4
%   'subg_deg_scale'  -- scale diffusion vector by node degrees before
%                         extracting subgraph?; default true
%   'rank_deg_scale'  -- scale diffusion vector by node degrees before
%                         ranking and getting new seeds?; default true
%
% OUTPUTS
%   new_seedset       - new seed set, from a diffusion on a subgraph

% PARAMETERS
p = inputParser;
p.addOptional('subgraph_size', 500);
p.addOptional('num_new_seeds', 3);
p.addOptional('subg_method', 2);
p.addOptional('rank_method', 'ppr');
p.addOptional('alpha', 0.99);
p.addOptional('epsil', 1e-4);
p.addOptional('subg_deg_scale', true, @islogical);
p.addOptional('rank_deg_scale', true, @islogical);
p.parse(varargin{:});

num_new_seeds = p.Results.num_new_seeds;
subg_method_name = p.Results.subg_method;
rank_method_name = p.Results.rank_method;
set_limit = p.Results.subgraph_size;
alpha = p.Results.alpha;
epsil = p.Results.epsil;
n = size(A,1);
output_size = length(seed_set) + num_new_seeds;

if subg_method_name ~= 0,
  % [1] EXTRACT SUBGRAPH
  [temp_subgraph, extracted_size] = subgraph_extraction(A, seed_set, 'method', subg_method_name, ...
      'set_limit', set_limit, 'alpha', alpha, 'epsil', epsil, 'deg_scale', p.Results.subg_deg_scale );

  output_size = min(length(temp_subgraph), length(seed_set) + num_new_seeds);

  A = A(temp_subgraph, temp_subgraph);
  seed_set = [1:min(length(seed_set), length(temp_subgraph))]; % get the actual input seeds inside this subgraph.
  n = size(A,1);
end

% [2] COMPUTE DIFFUSION ON SUBGRAPH
ranking = subgraph_extraction(A, seed_set, 'method', rank_method_name, ...
    'set_limit', n, 'alpha', alpha, 'epsil', epsil, 'deg_scale', p.Results.rank_deg_scale );

% [3] GET ACTUAL OUTPUT SEEDS FROM SUBGRAPH DIFFUSION
if subg_method_name ~= 0,
  ranking = temp_subgraph(ranking);
end
new_seedset = ranking( 1:min(output_size, length(ranking)) );

end
