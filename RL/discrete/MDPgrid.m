function [MDP] = MDPgrid(gSize, nGrids, Goal, nA, success)
% function [MDP] = MDPgrid(GRIDSIDE)
% function [MDP] = MDPgrid(GRIDSIDE, NGRIDS)
% function [MDP] = MDPgrid(GRIDSIDE, NGRIDS, GOAL)
% function [MDP] = MDPgrid(GRIDSIDE, NGRIDS, GOAL, nA)
%
% Creates an MDP struct with several gridworlds tied among themselves.
% Each gridworld has GRIDSIDE * GRIDSIDE states, and there are a total of
% NGRIDS such gridworlds, tied in a circular fashion (grid 1 is tied to
% grid 2, grid 2 is tied to grid 3, ..., grid NGRIDS is tied to grid 1).
% These are tied via the 2nd action in the last state in each grid, that
% leads to the first state in the next grid.
%
% The final MDP will have a total of GRIDSIDE^2 * NGRIDS states and 5 actions
% (N, S, E, W and NOOP).

IND_REWARD = 1;

% Parse input parameters

if (nargin < 1)
    error('Not enough input arguments. Usage: MDPGRID(SIZE) or MDPGRID(SIZE, GRIDS) or MDPGRID(SIZE, GRIDS, GOAL). Any of the last two arguments can be empty.');
end

% Initialize number of grids

if (nargin < 2 || isempty(nGrids))
    nGrids = 1;
end

% Initialize goal state

if (nargin < 3 || isempty(Goal))
    nGoals = max(1,ceil(0.02 * nGrids * gSize^2 * rand));
    Goal = ceil(nGrids * gSize^2 * rand(nGoals, 1));
else
    nGoals = length(Goal);
end

% Computer the number of states in each grid and the number of actions

nS = gSize^2;

if (nargin<4)
    nA = 5;
end

if (nargin<5)
    success = 1;
end

% Compute the indices for the transition probabilities

I0 = reshape(1:nS, gSize, gSize);                       % Original indices
IN = max(I0 - 1, I0(ones(gSize, 1), :));                % Indices after "N" action
IS = min(I0 + 1, I0(gSize * ones(gSize, 1), :));        % Indices after "S" action
IE = min(I0 + gSize, I0(:, gSize * ones(gSize, 1)));    % Indices after "E" action
IW = max(I0 - gSize, I0(:, ones(gSize, 1)));            % Indices after "W" action

% Vectorize indices

I0 = I0(:);
IN = IN(:);
IS = IS(:);
IE = IE(:);
IW = IW(:);

% Initialize transition matrix

P{1} = (1-success) * speye(nS * nGrids, nS * nGrids);           % N action
P{2} = (1-success) * speye(nS * nGrids, nS * nGrids);           % S action
P{3} = (1-success) * speye(nS * nGrids, nS * nGrids);           % E action
P{4} = (1-success) * speye(nS * nGrids, nS * nGrids);           % W action
if (nA>4)
    P{5} = speye(nS * nGrids, nS * nGrids);                 % NOOP action
end

% Fill each of the small gridworlds

for g = 1:nGrids

    % Fill probabilities for N action
    
    Idx = sub2ind(nGrids * [nS, nS], (g-1) * nS + I0, (g-1) * nS + IN);
    P{1}(Idx) = P{1}(Idx) + success; 

    % Fill probabilities for S action

    Idx = sub2ind(nGrids * [nS, nS], (g-1) * nS + I0, (g-1) * nS + IS);
    P{2}(Idx) = P{2}(Idx) + success; 

    % Fill probabilities for E action

    Idx = sub2ind(nGrids * [nS, nS], (g-1) * nS + I0, (g-1) * nS + IE);
    P{3}(Idx) = P{3}(Idx) + success; 

    % Fill probabilities for W action

    Idx = sub2ind(nGrids * [nS, nS], (g-1) * nS + I0, (g-1) * nS + IW);
    P{4}(Idx) = P{4}(Idx) + success;
    
    % Fill probabilities for between-grid transitions
    
    if (nGrids > 1)
        if (g < nGrids)
            P{2}(g * nS, g * nS + 1) = success;
        else
            P{2}(g * nS, 1) = success;
        end
        
        if (g > 1)
            P{3}(g * nS, (g-2) * nS + 1) = success;
        else
            P{3}(g * nS, (nGrids - 1) * nS + 1) = success;
        end

        P{2}(g * nS, g * nS) = (1-success);
        P{3}(g * nS, g * nS) = (1-success);
    end
end

if(nA==9)
    warning('MDPgrid: experimental')
    nA = 9;
    P{6} = (P{1}*P{4}+P{4}*P{1})/2; % NW action
    P{7} = (P{1}*P{3}+P{3}*P{1})/2; % NE action
    P{8} = (P{2}*P{4}+P{4}*P{2})/2; % SW action
    P{9} = (P{2}*P{3}+P{3}*P{2})/2; % SE action    
end

% Compute total states

nS = nS * nGrids;

% Compute rewards

R = sparse(nS, 1);
R(abs(Goal)) = sign(Goal);%IND_REWARD * (2 * (rand( nGoals, 1) > 0.5) - 1);

% Fill MDP structure

MDP = struct('nS', nS, 'nA', nA, 'P', {P}, 'R', R, 'Gamma', 0.95);