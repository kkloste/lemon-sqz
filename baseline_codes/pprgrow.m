function [bestset,bestcond,bestcut,bestvol,pagerankvector] = pprgrow(A,vert,varargin)
% PPRGROW Grow a cluster around a vertex using a PPR algorithm
%
% [bestset,cond,cut,vol,x] = pprgrow(A,vert) solves a PPR problem and
% extracts a cluster for various cluster volumes ranging from the degree
% of the vertex + 2 to the degree of the vertex + 300000.  In other words, 
% the goal is to find a cluster of up to 300000 additional edges nearby
% the seed vertex.  The returned cluster is the one that has the best
% conductance score among all the clusters found. The pagerank vector is
% returned as the vector x.
%
% [bestset,cond,cut,vol,x] = pprgrow(A,verts) solves a PPR problem that
% tries to find a set that is 2 to 300000 times the size of the input group
% of vertices. 
%
% ... pprgrow(A,verts,'key',value,'key',value) specifies optional arguments
%
% 'nruns' : specific the number of PPR runs.  The default is 32, which will
%   look for clusters with 2, 3, 4, 5, 10, 15, 20, 30, 40, 50, 100, 150, 
%   200, 300, 400, 500, 1000, 1500, 2000, 3000, 4000, 5000, 10000,
%   15000,  20000, 30000, 40000, 50000, 100000, 150000, 200000,
%   300000 additional edges for each vertex in the original set of vertices.  
%   This sequence will be continuned until nruns is exhausted.
% 'expands' : a custom sequence of target volumes to consider, e.g. to look
%   for clusters with 12 and 18 edges for each vertex in the original set,
%   then call pprgrow(A,verts,'expands',[12 18]).  
% 'maxexpand' : sets a limit on the largest value of the expansion
%   possible, in terms of number of edges.  The default value of this is
%   infinite, but a more reasonable value is nnz(A)/2.  This avoids
%   unnecessary work for larger graphs and can be used to uniformly limit
%   the size of the clusters.
%
% For more detail on these three parameters, please look at how they are
% used in the code.
%
% 'alpha' : the value of alpha to use in pagerank.  The default is 0.99.
%   Using a value of 0.999 is reasonable if your goal is to look for larger
%   clusters.

% warning('pprgrow:badDefaults',...
%    ['this file was edited for fair comparisons in the hkgrow package ' ...
%    'please see the neighborhoods package for better defaults']);

% MEX CODE USAGE
% [bestset,cond,cut,vol,prvec] = pprgrow_mex(A,set,targetvol,alpha)
% where
%   double pr_eps = 1.0/std::max(10.0*target_vol, 100.0);
% and set is the set of seed nodes


% David F. Gleich
% Purdue University, 2011
%
% Alterations made by Kyle Kloster
% Purdue University, 2015

p = inputParser;
p.addOptional('nruns',32,@isnumeric);
p.addOptional('alpha',0.99,@isnumeric);
p.addOptional('expands',[100,1000,10000,100000]);
p.addOptional('maxexpand',Inf,@isnumeric);
p.addOptional('neighborhood',false,@islogical);
p.parse(varargin{:});

expandseq = [2 3 4 5 10 15];
expands = [];
curmod = 1;
while numel(expands) < p.Results.nruns
    expands = [expands curmod*expandseq];
    curmod = curmod*10;
end
expands = expands(1:p.Results.nruns);

if p.Results.neighborhood
    neighs = find(A(:,vert));
    vert = union(vert,neighs);
end

if ~isempty(p.Results.expands)
    expands = p.Results.expands;
end

di=full(max(sum(A(:,vert))));

%expands = unique(round(logspace(log10(3),log10(p.Results.maxexpand),p.Results.nruns)));
bestcond = Inf;
bestset = [];
for ei=1:numel(expands)
    curexpand = expands(ei);
    if curexpand > p.Results.maxexpand, continue; end
    %fprintf('Called pprgrow on set of size=%i with expand=%i\n', numel(vert), curexpand);
    [curset cond cut vol pr_vec] = pprgrow_mex(A,vert,curexpand,p.Results.alpha);
    if cond < bestcond
        bestcond = cond;
        bestset = curset;
        bestvol = vol;
        bestcut = cut;
    end
end
pagerankvector = sparse( pr_vec(:,1), 1, pr_vec(:,2), size(A,1) , 1);% sparse vector
