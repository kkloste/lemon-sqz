function [cond cut vol inds] = cut_cond(A,set)
% function [cond cut vol inds] = cut_cond(A,set)
% input A must be symmetric and {0,1}-valued
  inds = set;

  totvol = nnz(A);
  n = size(A,1);
  e_S = sparse( inds, 1, 1, n, 1);
  Ae_S = A*e_S;
  vol = full( sum( Ae_S ) );
  cut = vol - full( e_S'*Ae_S );
  temp_vol = min(vol, totvol-vol);
  if temp_vol == 0,
      cond = 1;
      return;
  end
  cond = cut/temp_vol;
