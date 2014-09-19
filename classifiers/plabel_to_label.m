function Y = plabel_to_label(pY)
%PLABEL_TO_LABEL - Convert matrix of probabilistic labels to a vector label
%using an argmax function.
%
%   Syntax:  Y = plabel_to_label(pY)
%
%   Inputs:
%       pY - Labels probability [matrix (nObservations x nLabels)], each row sum to 1
%
%   Outputs:
%       Y - Label [vector (nObservations)]
%
%   Examples:
%       Y = plabel_to_label([0.9, 0.1; 0.54, 0.46; 0.3, 0.7])
%
%       Y =
% 
%            1
%            1
%            2
%
%   TODO:
%       Remove for loop
%       Test is pY is normalized
%       Add tests

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


[nObservations, nLabels] = size(pY);
pY_max = pY == repmat(max(pY, [], 2), 1, nLabels);

Y = zeros(nObservations, 1);
for iObservation = 1:nObservations
    Y(iObservation) = randsample(1:nLabels, 1, true, pY_max(iObservation, :));
end