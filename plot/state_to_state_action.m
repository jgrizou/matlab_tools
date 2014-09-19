function rewardStateAction = state_to_state_action(rewardState, transitions)
%STATE_TO_STATE_ACTION

nStates = size(rewardState);
nActions = length(transitions); 

rewardStateAction = zeros(nStates, nActions);    
for iState = 1:nStates
   for iAction = 1:nActions
       rewardStateAction(:, iAction) = rewardStateAction(:, iAction) + transitions{iAction}(:,iState) * rewardState(iState);
   end       
end

