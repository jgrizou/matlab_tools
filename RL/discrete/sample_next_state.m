function nextState = sample_next_state(MDP, startState, action)

nextStateProba = get_next_state_proba(MDP, startState, action);
nextState = sample_action_discrete_policy(nextStateProba, 1);

