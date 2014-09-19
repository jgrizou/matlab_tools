function probabilities = softmax(values, temperature)
%SOFTMAX Convert values into probabilities
%
%   Syntax: probabilities = softmax(values, temperature)
%
%   Inputs:
%       values - Value to normalize [matrix (nObservations x nValues), i.e. in RL most cases (nStates x nActions)]
%       temperature - temperature to apply [scalar \in (0+,+Inf)] - default is 1
%                     If temperature set to 0, then the winner(s) takes it all
%
%   Outputs:
%       probabilities - Each row are a discrete probability distribution [matrix (nObservations x nValues), i.e. in RL most cases (nStates x nActions)]
%
%   Example:
%
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

if ~ismatrix(values)
    error('softmax:InputDim', 'values must be 2-D.'); 
end
if nargin < 2
   temperature = 1; 
end
if ~isscalar(temperature)
    error('softmax:InputDim', 'temperature must be a scalar.'); 
end
if temperature < 0
    warning('softmax:TemperatureOutOfRange', 'temperature range between 0 and Inf')
end

if temperature == 0
    probabilities = values == repmat(max(values, [], 2), 1, size(values, 2));
else
    probabilities = exp(values / temperature) ./ repmat(sum(exp(values / temperature), 2), 1, size(values, 2));
end
