load us-string-91
A = A|A';
A = A-spdiags(diag(A),0,size(A,1),size(A,1) );
d = full(sum(A,2));
inds = find(d);
A = A(inds,inds);

%%

temp_index2label = zeros( length(inds), 1);
temp_label2index = containers.Map('KeyType', 'char', 'ValueType', 'double');
for j=1:length(inds),
    temp_index2label(j) = index2label{ inds(j) };
    temp_label2index( 