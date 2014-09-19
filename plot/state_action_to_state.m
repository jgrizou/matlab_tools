function rewardState = state_action_to_state(rewardStateAction, transitions)
%STATE_ACTION_TO_STATE

[nStates, nActions] = size(rewardStateAction);
rewardState = zeros(nStates, 1);
for iNextState = 1:nStates
   for iAction = 1:nActions
       for iState = 1:nStates
           rewardState(iNextState, 1) = rewardState(iNextState, 1) + transitions{iAction}(iState, iNextState) * rewardStateAction(iState, iAction); 
       end
   end       
end