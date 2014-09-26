function isValid = is_MDP_valid(MDP)
% for now onlycheck is transition proba are consistent, i.e. sum to one

%%
isValid = false;
for a = 1:length(MDP.P)
    for s = 1:size(MDP.P{a},1)
        if ~is_proba_normalized_row(MDP.P{a}(s,:))
            return
        end
    end
end
isValid = true;


