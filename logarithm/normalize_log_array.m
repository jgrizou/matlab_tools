function probabilities = normalize_log_array(loglikelihoods)
%NORMALIZE_LOG_ARRAY - Normalize an array of log value to a probability vector
%
%   Syntax: probabilities = normalize_log_array(loglikelihoods)
%
%   Inputs:
%       loglikelihoods - Vector of log values [vector (nElements)]
%
%   Outputs:
%       isNormalized - [boolean]
%
%   Example:
%       probabilities = normalize_log_array([log(0.9)+log(0.5),log(0.3)+log(0.6)])
%       % 0.9*0.5 + 0.3*0.6 = 0.63
%       % result should be [0.9*0.5/0.63, 0.3*0.6/0.63] = [0.7143, 0.2857]
%
%       probabilities =
% 
%           0.7143    0.2857
%
%   See also: add_lns, sub_lns

if ~isvector(loglikelihoods)
   error('normalize_log_array:InputDim', 'loglikelihoods must be a vector')
end

nElements = length(loglikelihoods);
if nElements > 1
    logSum = add_log_array(loglikelihoods);
    probabilities = exp(loglikelihoods - logSum);
else
   probabilities = 1; 
end
