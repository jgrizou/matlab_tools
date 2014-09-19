function loglikelihood = loglikelihood_plabel(predictedPLabel, truePLabel)
%LOGLIKELIHOOD_PLABEL Compute the loglikelihood of a good prediction given the predicted probabilistic
%label and the true probabilistic label.
%
%   Syntax:  loglikelihood = loglikelihood_plabel(predictedPLabel, truePLabel)
%
%   Inputs:
%       predictedPLabel - Labels probability [matrix (nObservations x nLabels)], each row sum to 1
%       truePLabel - Labels probability [matrix (nObservations x nLabels)], each row sum to 1
%
%   Outputs:
%       loglikelihood - Loglikelihood of a good prediction [scalar \in (-Inf,0)]
%
%   Example:
%       loglikelihood = loglikelihood_plabel([0.3, 0.7], [0.9, 0.1])
%       % you should expect log(0.3*0.9 + 0.7*0.1) = -1.0788
% 
%       loglikelihood =
% 
%           -1.0788
%
%   TODO:
%       Add tests

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if ~(is_proba_normalized_row(predictedPLabel) && is_proba_normalized_row(predictedPLabel))
   error('loglikelihood_plabel:InputNotNormlaized', 'plabel are not normalized') 
end

% realmin avoid computational problems
% if a probability is zero, then we assume the smallest possible number to
% still be able to compute the log of it.
loglikelihood = sum(log(sum(predictedPLabel .* truePLabel, 2)  + realmin));