function action = sample_action_discrete_policy(policy, state)
%SAMPLE_ACTION_DISCRETE_POLICY - Sample one action to execute at state from a policy
%The policy may be a sparse matrix.
%
%   Syntax:  action = sample_action_discrete_policy(state, policy)
%
%   Inputs:
%       policy - The policy matrix [matrix (nStates x nActions) - may be sparse]
%                Not mandatory that row sum to 1, we allow any non-negative matrix so we can use Q-Values for example
%       state - The state to evaluate action [scalar \in (1,nStates)]
%
%   Outputs:
%       action - Action to be performed [scalar \in (1,nActions)]
%
%   TODO:
%       Add tests
%       Add Examples

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/


if ~ismatrix(policy)
    error('sample_action_discrete_policy:InputDim', 'policy must be 2-D.'); 
end

if nargin < 2 && size(policy, 1) == 1
   state = 1; 
end

[nS, nA] = size(policy);
if state > nS || state < 1
    error('sample_action_discrete_policy:StateNonValid', 'The state is not valid.')
end

action = randsample(1:nA, 1, true, proba_normalize_row(full(policy(state,:)))); % we normalize row to avoid the [0, 0, 0] error