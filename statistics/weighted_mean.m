function weightedMean = weighted_mean(X, weights)
%WEIGHTED_MEAN - Weighted average value
% 
%   Syntax:  weightedMean = weighted_mean(X, weigths)
% 
%   Inputs:
%       X - Observation [matrix (nObservations x nFeatures)]
%       weigths - Weights of each observations [vector (nObservations x 1) or matrix (nObservations x nFeatures)]
% 
%   Outputs:
%       weightedMean - The weighted averaged value [vector (1 x nFeatures)]
% 
%   Example:
%       X = [20, 10; 30, 5];
%       weights = [0.75; 0.25];
%       weightedMean = weighted_mean(X, weights)
% 
%       weightedMean =
%     
%           22.5000    8.7500
%
%   See also MEAN

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if nargin==0 
    error('weighted_mean:NotEnoughInputs','Not enough input arguments.'); 
end
if ~ismatrix(X)
    error('weighted_mean:InputDim', 'X input must be 2-D.'); 
end
if size(X, 1) ~= size(weights, 1)
    error('weighted_mean:InputDim', 'X and weights must have the same number of elements.'); 
end
if size(weights, 2) ~= 1 && size(weights, 2) ~= size(X, 2) 
    error('weighted_mean:InputDim', 'weights must be a vector or a matrix of same dimensions as X.'); 
end

if size(weights,2) == 1
    weights = repmat(weights, 1, size(X, 2));
end

weightedMean =  sum(X .* weights, 1) ./ sum(weights, 1);
    