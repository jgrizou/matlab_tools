function weightedCov = weighted_cov(X, weights, weightedMean)
%WEIGHTED_COV - Weighted covariance matrix
%
%   Syntax:  weightedCov = weighted_cov(X, weigths, weigthedMean)
%
%   Inputs:
%       X - Observation [matrix (nObservations x nFeatures)]
%       weigths - Weights of each observations [vector (nObservations x 1)]
%       weigthedMean (optional)- Mean according to the weights [vector (1 x nFeatures)]
%
%   Outputs:
%       weightedCov - The weighted covariance matrix [matrix (nFeatures x nFeatures)]
%
%   TODO:
%       Add Examples
%
%   See also COV

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if nargin==0 
    error('weighted_cov:NotEnoughInputs','Not enough input arguments.'); 
end
if ~ismatrix(X)
    error('weighted_cov:InputDim', 'X must be 2-D.'); 
end
if size(X, 1) ~= size(weights, 1)
    error('weighted_cov:InputDim', 'X and weights must have the same number of elements.'); 
end

if nargin==2
    weightedMean = weighted_mean(X, weights);
else
    if size(weightedMean, 2) ~= size(X, 2)
        error('weighted_cov:InputDim', 'weightedMean must have the same dimension as X.'); 
    end 
end

X = X - repmat(weightedMean, size(X, 1), 1);
weightedCov = (X' * diag(weights) * X) / sum(weights);