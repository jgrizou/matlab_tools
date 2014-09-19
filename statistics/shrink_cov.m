function regCov = shrink_cov(cov, lambda)
%SHRINK_COV - Regularize covariance matrix by the shinkage method
%
%   Syntax:  regCov = shrink_cov(cov, lambda)
%
%   Inputs:
%       cov - A covariance matrix [matrix (nFeatures x nFeatures)]
%       lambda - The shrinkage coefficient [scalar \in (0,1)]
%
%   Outputs:
%       regCov - The regularized covariance matrix [matrix (nFeatures x nFeatures)]
%
%   TODO:
%       Better doc of lambda
%       Add tests
%       Add Examples

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if ~ismatrix(cov)
    error('shrink_cov:InputDim', 'cov must be 2-D.'); 
end
if ~isscalar(lambda)
    error('shrink_cov:InputDim', 'lambda must be scalar.');
end
if lambda < 0 || lambda > 1
    error('shrink_cov:InputDim', 'lambda must range between 0 and 1.');
end

regCov = (1 - lambda) * cov + (lambda / length(cov)) * trace(cov) * eye(size(cov));
