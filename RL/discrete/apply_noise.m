function noisyPolicy = apply_noise(policy, noise)
%APPLY_NOISE - Assume policy for a perfect teacher and apply the noise to actions that have zero
%probability yet. By following such policy, the agent should therefore use a non optimal action noise percent of the time.
%
%   Syntax: noisyPolicy = apply_noise(policy, noise)
%
%   Inputs:
%       policy - Agent policy, i.e. the probabily of each action [matrix (nState x nAction)]
%                Not required to sum to 1 to make it easier to use, see examples
%       noise - noise level to apply [scalar \in (0,1)]
%               As a logical rule, the error rate should not exceed 0.5 in practice
%
%   Outputs:
%       noisyPolicy - Noisy policy [vector (nLabels)]
%                     Rows sum to 1.
%
%   Example:
%       noisyPolicy = apply_noise([0.5, 0, 0, 0.5], 0.1)  
% 
%       noisyPolicy =
% 
%           0.4500    0.0500    0.0500    0.4500
% 
%       noisyPolicy = apply_noise([1, 0, 1; 0, 0, 1], 0.05)  % for ease of use there is no need to normalize labels
% 
%       noisyPolicy =
% 
%           0.4750    0.0500    0.4750
%           0.0250    0.0250    0.9500
%
%   TODO:
%       Add tests, test the case [1,1,1] and [0,0,0]

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if ~ismatrix(policy)
    error('apply_noise:InputDim', 'policy must be 2-D.'); 
end
if ~isscalar(noise)
    error('apply_noise:InputDim', 'labels noise be a scalar.'); 
end
if noise < 0 || noise > 1
    warning('apply_noise:NoiseOutOfRange', 'noise range between 0 and 1')
end

[~, nAction] = size(policy);
noisyPolicy = proba_normalize_row(policy) * (1 - noise);
rowNoise = noise ./ sum(noisyPolicy == 0, 2);
rowNoise(isnan(rowNoise)) = 1;
rowNoise(isinf(rowNoise)) = 1;
rowNoise = repmat(rowNoise, 1, nAction);
rowNoise(noisyPolicy ~= 0) = 0;
noisyPolicy = noisyPolicy + rowNoise;