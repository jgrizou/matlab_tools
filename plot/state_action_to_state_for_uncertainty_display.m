function rewardState = state_action_to_state_for_uncertainty_display(rewardStateAction, transitions)
%STATE_ACTION_TO_STATE_FOR_UNCERTAINTY_DISPLAY

[nStates, nActions] = size(rewardStateAction);
rewardState = ones(nStates, 1) * -Inf;    
for iNextState = 1:nStates
   for iAction = 1:nActions
       for iState = 1:nStates
           if transitions{iAction}(iState, iNextState) > 0
               R = transitions{iAction}(iState, iNextState) * rewardStateAction(iState, iAction);
               if R > rewardState(iNextState, 1)
                   rewardState(iNextState, 1) = R;
               end
           end
       end
   end       
end