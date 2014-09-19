function action = greedy_action_discrete_policy(policy, state)
%GREEDY_ACTION_DISCRETE_POLICY - Select the most probable action to perform at state according to policy
%
%   Syntax:  action = action = greedy_action_discrete_policy(policy, state)
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

[nS, ~] = size(policy);
if state > nS || state < 1
    error('greedy_action_discrete_policy:StateNonValid', 'The state is not valid.')
end

greedy_policy = full(policy(state,:));
greedy_policy(greedy_policy ~= max(greedy_policy, [], 2)) = 0;
action = sample_action_discrete_policy(greedy_policy, 1);