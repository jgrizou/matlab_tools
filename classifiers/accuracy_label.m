function accuracy = accuracy_label(predictedLabel, trueLabel)
%ACCURACY_LABEL - Compute correctly predicted label as a percentage of dataset size
%
%   Syntax:  accuracy = accuracy_label(predictedLabel, trueLabel)
%
%   Inputs:
%       predictedLabel - Label [vector (nObservations)]
%       trueLabel - Label [vector (nObservations)]
%
%   Outputs:
%       accuracy - Ratio of correctly predicted [scalar \in (0,1)]
%
%   Examples:
%       accuracy = accuracy_label([1, 1, 2], [2, 1, 2])
% 
%       accuracy =
% 
%           0.6667
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

accuracy = mean(predictedLabel == trueLabel);