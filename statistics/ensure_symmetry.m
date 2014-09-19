function symM = ensure_symmetry(M)
%ENSURE_SYMMETRY - Ensure symmetry of a matrix M
%
%   Syntax:  symM = ensure_symmetry(M)
%
%   Inputs:
%       M - A matrix [matrix (nFeatures x nFeatures)]
%
%   Outputs:
%       symM - An ensured symmetric matrix [matrix (nFeatures x nFeatures)]


%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if ~ismatrix(M)
    error('ensure_symmetry:InputDim', 'M must be 2-D.'); 
end
if (any(isnan(M) | isinf(M) | ~isreal(M)))
    warning('ensure_symmetry:ComplexInfNaN', 'M contains complex numbers, Inf, or NaN'); 
end

symM = (M + M') / 2;