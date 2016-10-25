load usps_3nn;

%%
rows = [];
cols = [];

uniq_labs = unique(labels);
m = length(uniq_labs);
n = size(A,1);

for col=1:m,
    inds = find(labels==col);
    rows = [rows;inds];
    cols = [cols; col*ones(length(inds),1)];
end
C = sparse( rows, cols, 1, n, m);

% Check for correctness:
for j=1:size(C,2),
    inds = find(C(:,j));
    inds2 = find(labels==j);
    assert( 1 == length(intersect(inds,inds2))/length(union(inds,inds2)), ...
        sprintf('MISMATCH j=%d',j) );
end

save('usps_3nn','A','C');