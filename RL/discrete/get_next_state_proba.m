function nextStateProba = get_next_state_proba(MDP, startState, action)

nextStateProba = MDP.P{action}(startState, :);