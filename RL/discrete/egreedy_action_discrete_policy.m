function action = egreedy_action_discrete_policy(policy, state, epsilon)
%EGREEDY_ACTION_DISCRETE_POLICY - Select the most probable action to perform at state according to policy
%
%   Syntax:  action = egreedy_action_discrete_policy(policy, state, epsilon)
%
%   Inputs:
%       policy - The policy matrix [matrix (nStates x nActions) - may be sparse]
%                Not mandatory that rows sum to 1, we allow any non-negative matrix so we can use Q-Values for example
%       state - The state to evaluate action [scalar \in (1,nStates)]
%       epsilon - Percentage of the time the agent pick a non-optimal action [scalar \in (0, 1)]
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

egreedy_policy = full(policy(state,:));
egreedy_policy(egreedy_policy ~= max(egreedy_policy, [], 2)) = 0;
egreedy_policy = apply_noise(egreedy_policy, epsilon);
action = sample_action_discrete_policy(egreedy_policy, 1);