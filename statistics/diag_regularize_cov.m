function regCov = diag_regularize_cov(cov, regCst)
%DIAG_REGULARIZE_COV - Regularize covariance matrix by adding constant to the
%diagonal
%
%   Syntax:  regCov = diag_regularize_cov(cov, regCst)
%
%   Inputs:
%       cov - A covariance matrix [matrix (nFeatures x nFeatures)]
%       regCst - The regCst [scalar or vector (nFeatures)]
%
%   Outputs:
%       regCov - The regularized covariance matrix [matrix (nFeatures x nFeatures)]
%
%   TODO:
%       Add Examples

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if ~ismatrix(cov)
    error('diag_regularize_cov:InputDim', 'cov must be 2-D.'); 
end
if ~isvector(regCst)
    error('diag_regularize_cov:InputDim', 'regCst must be 1-D.');
end
if length(regCst) ~= 1 && length(regCst) ~= length(cov)
    error('diag_regularize_cov:InputDim', 'cov and regCst must have the same number of dimensions.'); 
end

nFeatures = length(cov);

if length(regCst) == 1
    regCst = ones(nFeatures, 1) * regCst;
end

regCov = cov + diag(regCst);