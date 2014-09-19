function pX = proba_normalize_row(X)
%PROBA_NORMALIZE_ROW - Normalizes the rows of a matrix to 1
%
%   Syntax: pX = proba_normalize_row(X)
%
%   Inputs:
%       X - Non-negative weight matrix [matrix (nObservations x nValues)]
%
%   Outputs:
%       pX - Normalized X, each row is a discrete probability distribution [matrix (nObservations x nValues)]
%
%   Example:
%       X = [20, 10; 30, 5];
%       pX = proba_normalize_row(X)
% 
%       pX =
% 
%           0.6667    0.3333
%           0.8571    0.1429
%
%   TODO:
%       Add tests with negative value, [0, 0, 0]

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if ~ismatrix(X)
    error('proba_normalize_row:InputDim', 'Inputs must be 2-D.');
end

if any(any(X < 0))
    error('proba_normalize_row:NegativeValue', 'X must contain only non-negative values');
end

%If one row is full of zero fill it with a positive number (here 1)
nul = find(any(X, 2) == 0);
X(nul,:) = ones(size(nul, 1), size(X, 2));

pX = X ./ repmat(sum(X, 2), 1, size(X, 2));