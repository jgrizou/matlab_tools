function isNormalized = is_proba_normalized_row(X, tol)
%IS_PROBA_NORMALIZED_ROW Check whether X rows sum to 1
%
%   Syntax: isNormalized = is_proba_normalized_row(X)
%           isNormalized = is_proba_normalized_row(X, tol)
%
%   Inputs:
%       X - Non-negative weight matrix [matrix (nObservations x nValues)]
%       tol - The tolerance to which sum of rows should equals 1 [scalar] (optional)
%             default = 1e-6
%
%   Outputs:
%       isNormalized - [boolean]
%
%   Example:
%       isNormalized = is_proba_normalized_row([0, 1; 0.5, 0.5])
%       isNormalized =
% 
%            1

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if ~ismatrix(X)
    error('is_proba_normalized_row:InputDim', 'Inputs must be 2-D.');
end

if nargin  < 2
    tol = 1e-6;
end

diff = abs(sum(X, 2) - ones(size(X, 1), 1));
isNormalized = all(diff < tol);