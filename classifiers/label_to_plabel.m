function pY = label_to_plabel(Y, pBest, nLabels)
%LABEL_TO_PLABEL - Convert vector label to matrix of probabilistic labels
%
%   Syntax:  pY = label_to_plabel(Y, pBest)
%
%   Inputs:
%       Y - Label [vector (nObservations)]
%       pBest - Probability value of the true label [scalar \in (0,1) (default is 1)]
%       nLabels - Number of labels [positive integer] - just in case not all label are present in Y
%
%   Outputs:
%       pY - Labels probability [matrix (nObservations x nLabels)], each row sum to 1
%
%   Examples:
%       pY = label_to_plabel([1;1;2;2], 0.9)
%
%       pY =
% 
%           0.9000    0.1000
%           0.9000    0.1000
%           0.1000    0.9000
%           0.1000    0.9000
%
%   TODO:
%       Remove for loop
%       Add tests

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if nargin < 2
    pBest = 1;
end

nObservations = length(Y);
[labels, ~, indices] = unique(Y);
if nargin < 3
    nLabels = length(labels);
end

pY = ones(nObservations, nLabels) * (1 - pBest) / (nLabels - 1);
for iObservation = 1:nObservations
    pY(iObservation, indices(iObservation)) = pBest;
end