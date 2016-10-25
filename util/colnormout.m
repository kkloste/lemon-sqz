function P = colnormout(A)
% COLNORMOUT Normalize the columns of the matrix A.  
%
% P = colnormout(A)
%
%   P has the same non-zero structure as A, but is normalized such that the
%   sum of each column is 1, assuming that A has non-negative entries. 
%

%
% colnormout.m
% David Gleich
% minor adjustment by Kyle Kloster December 2013
% Revision 1.01
% 19 Octoboer 2005
%

% compute the row-sums/degrees
d = full(sum(A,1));

% invert the non-zeros in the data
id = spfun(@(x) 1./x, d);

% scale the rows of the matrix
P = A*diag(sparse(id));
