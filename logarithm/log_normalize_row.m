function pX = log_normalize_row(logX)
%LOG_NORMALIZE_ROW - Normalizes the rows of a log matrix to probabilities summing to 1
%
%   Syntax: pX = log_normalize_row(logX)
%
%   Inputs:
%       logX - Non-negative log value matrix [matrix (nObservations x nValues)]
%
%   Outputs:
%       pX - Normalized logX, each row is a discrete probability distribution [matrix (nObservations x nValues)]
%
%   Example:
%       logX = log([20, 10; 30, 5]);
%       pX = log_normalize_row(logX)
% 
%       pX =
% 
%           0.6667    0.3333
%           0.8571    0.1429

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if ~ismatrix(logX)
    error('log_normalize_row:InputDim', 'Inputs must be 2-D.');
end

[nObservations, nValues] = size(logX);

pX = zeros(nObservations, nValues);
for iObservation = 1:nObservations
    pX(iObservation,:) = normalize_log_array(logX(iObservation,:));
end



