function [x_old, x_pos, jaccards] = lemon_coeffs(Abar,S,k,l)
% [x_old, x_pos, jaccards] = lemon_coeffs(Abar,S,k,l)
%
% INPUTS
%   Abar    - normalized adjacency matrix, (D^-.5*(A+I)*D^-.5)
%   S       - seed set
%   k,l     - determine size of the Krylov subspace,
%               K(k,l) = [ Abar^(k)*v, ..., Abar^(k+l)*v ]
%
% OUPUTS
%   x_old       - from y = V*x, determined by original LEMON.
%   x_pos       - coeffs x from LEMON opt modified so x >= 0
%   jaccards    - jaccard index of top 5,10,15,20 nodes identified by each
%                   of the two lemon vectors, i.e. "old" and "pos"
%
% Code for testing questions regarding coefficients computed in
% "Uncovering small structure in large networks"
% [Li, He, Bindel, Hopcroft 2015]


n = size(Abar,1);
p = sparse( S, 1, 1, n, 1);

% Construct local spectral subspace
V = zeros(n,l);
temp = p;
for j=1:(k-1),
    temp = Abar*temp;
end
for j=1:l,
    temp = Abar*temp;
    V(:,j) = temp;
end

V_S = full(V(S,:));
eV = full(sum(V,1));
len_x = size(V,2);
% Compute LEMON
cvx_begin quiet
    cvx_precision high
    variable x(len_x);
    minimize eV*x
    subject to
        V_S*x >= 1;
        V*x >= 0; 
cvx_end
x_old = x;

cvx_begin quiet
    cvx_precision high
    variable x(len_x);
    minimize eV*x
    subject to
        V_S*x >= 1;
        x >= 0; 
cvx_end
x_pos = x;

y_old = V*x_old;
y_pos = V*x_pos;
[~, perm_old] = sort( y_old, 'descend');
[~, perm_pos] = sort( y_pos, 'descend');
jaccards = zeros(4,1);

for j=1:length(jaccards),
    topj = 5*j;
    jaccards(j) = jaccard_index( perm_old(1:topj), perm_pos(1:topj) );

end

end% END OUTER FUNCTION
