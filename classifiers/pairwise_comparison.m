function pairwiseComparedElements = pairwise_comparison(anonymousFunction, elements)
%COMPUTE_SIMILARITY Compute upper diagonal of the pairwise matrix.
%This function is similar to the matlab pdist function but more general as an element can be anything (struct, cell, class, ...).
%The anonymousFunction takes two elements in input
%
%   Syntax:  pairwiseComparedElements = pairwise_comparison(anonymousFunction, elements)
%
%   Inputs:
%       anonymousFunction - An anonymous function (@(element1, element2)...) that returns a scalar value [scalar] when given two elements as inputs 
%       elements - A cell vector of elements to be compared [cell vector (nElements)]
%
%   Outputs:
%       pairwiseComparedElements - Ouput of anonymousFunction for each comparison
%                                  Ordered the same way as pdist (so you can use squareform(pairwiseComparedElements) if needed)
%
%   Examples:
%       pairwiseComparedElements = pairwise_comparison(@(x, y) x + y, {1, 2, 3, 4})
% 
%       pairwiseComparedElements =
% 
%           3     4     5     5     6     7
% 
%       squareform(pairwiseComparedElements)
%           
%         ans =
% 
%              0     3     4     5
%              3     0     5     6
%              4     5     0     7
%              5     6     7     0
%
%
%   TODO:
%       Add tests
%
%   See also PDIST, SQUAREFORM

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if ~isvector(elements)
    error('pairwise_comparison:InputDim', 'elements must be 1-D.'); 
end
if ~iscell(elements)
    error('pairwise_comparison:InputType', 'elements must be a vector of cell.'); 
end

idx = 0;
nElements = length(elements);
nPair = nElements * (nElements - 1) / 2;
pairwiseComparedElements = zeros(1, nPair);
for i = 1:nElements
    for j = (i + 1):nElements
        idx = idx + 1;
        pairwiseComparedElements(idx) = anonymousFunction(elements{i}, elements{j});
    end
end