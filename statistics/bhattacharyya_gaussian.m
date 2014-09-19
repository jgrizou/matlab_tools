function [bhattacharyyaDistance, bhattacharyyaCoefficient] = bhattacharyya_gaussian(mean1, cov1, mean2, cov2)
%BHATTACHARYYA_GAUSSIAN - Bhattacharyya distance and coefficient between
%two multivariate normal distributions
%
%   Syntax:  [bhattacharyyaDistance, bhattacharyyaCoefficient] = bhattacharyya_gaussian(mean1, cov1, mean2, cov2)
%
%   Inputs:
%       mean1 - Mean of first distribution value [vector (nFeatures)]
%       cov1 - Covariance matrix of first distribution [matrix (nFeatures x nFeatures)]
%       mean2 - Mean of second distribution value [vector (nFeatures)]
%       cov2 - Covariance matrix of second distribution [matrix (nFeatures x nFeatures)]
%
%   Outputs:
%       bhattacharyyaDistance - The bhattacharyya distance [positive scalar]
%       bhattacharyyaCoefficient - The bhattacharyya distance [scalar \in (0,1)]
%
%   TODO:
%       Better doc of bhattacharyya
%       Add test
%       Add Examples

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if ~ismatrix(cov1) || ~ismatrix(cov2)
    error('bhattacharyya_gaussian:InputDim', 'Covariances must be 2-D.'); 
end
if ~isvector(mean1) || ~isvector(mean2)
    error('bhattacharyya_gaussian:InputDim', 'Means must be 1-D.');
end
if length(mean1) ~= length(cov1) || length(mean2) ~= length(cov2) || length(mean1) ~= length(mean2)
    error('bhattacharyya_gaussian:InputDim', 'Both distribution must have the same dimensionality.');
end

cov = (cov1 + cov2) / 2;
temp = det(cov) / sqrt(det(cov1) * det(cov2));
bhattacharyyaDistance = (1/8) * ((mean1 - mean2) * pinv(cov)) * (mean1 - mean2)' + (1/2) * log(temp);
bhattacharyyaCoefficient = exp(-bhattacharyyaDistance);
if bhattacharyyaCoefficient > 1 % a tiny bit above but that happens due to computational problems
    bhattacharyyaCoefficient = 1;
end