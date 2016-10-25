function [output_subgraph, extracted_size] = subgraph_extraction(A, seed_set, varargin)
% [output_subgraph, extracted_size] = subgraph_extraction(A, seed_set, varargin)
  % INPUTS
  %   A                   - adjacency matrix
  %   seed_set            - small set of nodes
  %
  % varargin:
  %   'set_limit'   -- max size of output, default value min(3000, (size of A)/5 )
  %   'method'      -- input 'ppr' to use PageRank, 'hk' for heat kernel,
  %                   or an integer k>=1 to use a k-walk.
  %   'alpha'       -- ppr (alpha) / hk (t) parameter; default 0.99
  %   'epsil'       -- accuracy used in ppr/hk, default 1e-4
  %   'deg_scale'   -- scale ppr vector by node degrees?, default true
  %   'ppr_auto_tune' -- set to true to have alpha and epsil autoset; default false
  %
  % OUTPUTS
  %   output_subgraph     - set of nodes surrounding seed_set
  %   extracted_size      - size of subgraph extracted, before altering

  n = size(A,1);

  % PARAMETERS
  p = inputParser;
  p.addOptional('set_limit', min(3000, ceil(n/5) ) );
  p.addOptional('method', 'ppr');
  p.addOptional('alpha', 0.99);
  p.addOptional('epsil', 1e-4);
  p.addOptional('deg_scale', true, @islogical);
  p.addOptional('ppr_auto_tune', false, @islogical);
  p.parse(varargin{:});

  method_name = p.Results.method;
  set_limit = p.Results.set_limit;
  epsil = p.Results.epsil;
  alpha = p.Results.alpha;
  ppr_auto_tune = p.Results.ppr_auto_tune;

if ppr_auto_tune == true,
	ave_deg = nnz(A) / n;
	expected_num_nodes = set_limit;
	expected_volume = ave_deg * expected_num_nodes ;
	temp = 1/(200*expected_volume);
	epsil = temp^(2/3);
	alpha = 1 - temp^(1/3);
end

  switch method_name
    case 'ppr'
      % use pagerank vector
      temp = pprvec_mex(A,seed_set,epsil,alpha);
      inds = temp(:,1);
      vals = temp(:,2);

    case 'hk'
      % use heat kernel vector
      temp = hkvec_mex(A,seed_set,alpha,epsil);
      inds = temp(:,1);
      vals = temp(:,2);

    otherwise
      walk_k = p.Results.method ;
      assert( isnumeric(walk_k), 'Input method_name not valid\n' );
      iter_vec = sparse_k_walk( A, seed_set, walk_k );
      [inds, ~, vals] = find(iter_vec);

  end % end switch

  if p.Results.deg_scale == true,
    temp_vec = sparse( inds, 1, vals, n, 1 );
    temp_vec = sparse_degpower_mex(A, temp_vec, -1.0);
    inds = temp_vec(:,1);
    vals = temp_vec(:,2);
  end
  [~, permut] = sort(vals,'descend');
  sorted_inds = inds(permut);
  sorted_inds = union(seed_set, sorted_inds, 'stable');
  output_subgraph = sorted_inds(1:min(set_limit, length(sorted_inds)));
  extracted_size = length(permut);


end
