function psdM = ensure_positive_semidefinite(M)
%ENSURE_POSITIVE_SEMIDEFINITE - Ensure M is positive semidefinite. Negative
%eigenvalues will be force ot 0 and the matrice re-projected.
%
%   Syntax:  psdM = ensure_positive_semidefinite(M)
%
%   Inputs:
%       M - A matrix [matrix (nFeatures x nFeatures)]
%
%   Outputs:
%       psdM - An ensured positive semidefinite matrix [matrix (nFeatures x nFeatures)]


%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if (any(isnan(M) | isinf(M) | ~isreal(M)))
    warning('ensure_positive_semidefinite:ComplexInfNaN', 'M contains complex numbers, Inf, or NaN'); 
end
% Drop any negative eigenvalues.
psdM = M;
[V, D] = eig(full(psdM));
d = real(diag(D));
if (any(d < 0))
  warning('ensure_positive_semidefinite:NegativeEigenvalues', ['S is not positive semidefinite (min. eig. = ', num2str(min(d)), ' ; projecting.']);
  d(d < 0) = 0;
  D = diag(d);
  psdM = V * D * V';
end
psdM = ensure_symmetry(psdM);