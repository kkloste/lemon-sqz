function [output_cluster, subg_size] = lemon_simple( A, S, varargin)
% [output_cluster, subg_size] = lemon_simple( A, S, varargin)
%
% INPUTS
%   A    - adjacency matrix
%   S       - seed set
%
%   varargin:
%   seed_augment_size - default 6, determines size of increase of seed set
%   num_augment_steps - default 10, determines num of seed set increases
%   subgraph_size     - default 3000, size of initial subgraph extracted
%   sweep_range       - default [1,subgraph_size],  determines interval of
%                       lemon vector indices swept over
%   auto_stop         - default true, checks for conductance reaching a local
%                       minimum to determine when to terminate
%   final_sweep       - default false; performs one last sweep over output cluster
%                       to guarantee returned cluster is of min conductance
%
% OUPUTS
%   output_cluster        - proposed cluster
%   subg_size             - size of subgraph extracted before LEMON computed

  % [0] PARAMETERS
  %   settings recommended in Li et al. paper
    p = inputParser;
    p.addOptional('num_augment_steps',10);
    p.addOptional('seed_augment_size',6);
    p.addOptional('subgraph_size',3000);
    p.addOptional('sweep_range',[1,0]);
    p.addOptional('auto_stop',true, @islogical);
    p.addOptional('final_sweep', false, @islogical);
    p.parse(varargin{:});
    auto_stop = p.Results.auto_stop;
    final_sweep = p.Results.final_sweep;
    num_augment_steps = p.Results.num_augment_steps;
    seed_augment_size = p.Results.seed_augment_size;
    set_limit = p.Results.subgraph_size;
    sweep_range = [1,set_limit];
    input_sweep_range = p.Results.sweep_range;
    sweep_range(1) = max( sweep_range(1), input_sweep_range(1) );
    if input_sweep_range(2) > 0,
      sweep_range(2) = max( sweep_range(1), min( input_sweep_range(2), set_limit ) );
    end

  % [1] SUBGRAPH EXTRACTION ("sub-sampling")
    [subgraph_indices] = subgraph_extraction(A, S, 'set_limit', set_limit, ...
        'method', 'ppr', 'ppr_auto_tune', true );

    A_sub = A(subgraph_indices, subgraph_indices);
    n_sub = size(A_sub,1);
    subg_size = n_sub;

    degs_sub = full(sum(A_sub,2));
    Dsub_sqinv = spdiags( degs_sub.^-0.5, 0, n_sub, n_sub);
    Abar_sub = Dsub_sqinv*(A_sub + speye(n_sub))*Dsub_sqinv;

    S_sub = [];
    for j=1:length(S),
      S_sub = [S_sub; find( subgraph_indices == S(j) )];
    end

% [2] SEED AUGMENTATION
    S_current = S_sub;
    conductances = ones(num_augment_steps+2,1);
    conductances(1) = 0.0;
    conductances(2) = cut_cond(A_sub, S_current);
    for which_step = 1:num_augment_steps,

        % get diffusion vector
        p0 = zeros(n_sub,1);
        p0(S_current) = 1/length(S_current);
        lemon_vec = (Abar_sub*(Abar_sub*(Abar_sub*p0)));

        [~,sort_inds] = sort(lemon_vec,'descend');

        if auto_stop == true,
            % get current conductance
            [node_set, cond_current] = sweepcut(A_sub,sort_inds,'inputnodes',true,'sweeprange',sweep_range);
            conductances(which_step+2) = cond_current;

            % check termination criterion:

            if ( (conductances(which_step+1) < cond_current) ...
            && (conductances(which_step+1) < conductances(which_step)) ),
                break;
            end
        end

        % augment current seed set
        augment_size = min(seed_augment_size*which_step, length(sort_inds));
        S_current = union( S_current, sort_inds(1:augment_size) );
    end
    if final_sweep == true,
        S_current = union(S_current, sort_inds);
        S_current = sweepcut( A_sub, S_current, 'inputnodes', true, 'sweeprange', sweep_range );
    end

    output_cluster = subgraph_indices( S_current );

end
