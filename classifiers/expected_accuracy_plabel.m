function expectedAccuracy = expected_accuracy_plabel(predictedPLabel, truePLabel)
%EXPECTED_ACCURACY_PLABEL - Compute expected accuracy given the predicted probabilistic
%label and the true probabilistic label. Assumes all observations weight the same.
%
%
%   Syntax:  expectedAccuracy = expected_accuracy_plabel(predictedPLabel, truePLabel)
%
%   Inputs:
%       predictedPLabel - Labels probability [matrix (nObservations x nLabels)], each row sum to 1
%       truePLabel - Labels probability [matrix (nObservations x nLabels)], each row sum to 1
%
%   Outputs:
%       expectedAccuracy - Ratio of correctly predicted [scalar \in (0,1)]
%
%   Example:
%       expectedAccuracy = expected_accuracy_plabel([0.3, 0.7; 1, 0], [0.9, 0.1; 0.5, 0.5])
%       % you should expect (0.3*0.9 + 0.7*0.1)/2 + 0.5/2 = 0.42
% 
%       expectedAccuracy =
% 
%           0.4200
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
   error('expected_accuracy_plabel:InputNotNormlaized', 'plabel are not normalized') 
end

expectedAccuracy = mean(sum(predictedPLabel .* truePLabel, 2));
