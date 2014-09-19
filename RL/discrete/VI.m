function [Q, P] = VI(MDP, MAX_ERR)
% function [Q, P] = VI(MDP)
%
% This function computes the optimal policy for the given MDP. It outputs
% the optimal Q-function Q and the optimal policy P.
%
% MDP is a tuple MDP = (nS, nA, P, R, Gamma, X0). It is represented as a
% struct with the following fields:
%
% . 'nS'  - The number of states of the MDP;
% . 'nA'  - The number of actions of the MDP;
% . 'P'   - A cell array in which each component P{a} is a sparse nS x nS 
% matrix with the transition probabilities associated with action a;
% . 'R'   - A matrix with the reward function. R is either a nS x 1 vector
% (eventually sparse), a nS x nA (eventually sparse) matrix or a cell array
% in which each component R{a} is a sparse nS x nS matrix;
% . Gamma - The discount factor;
% . X0    - An optional initial state.

% Function constants


if (nargin < 1)
    error('Not enough input arguments. Usage: VI(MDP) or VI(MDP, MAX_ERR).');
end

if (nargin < 2)
    MAX_ERR = 1e-18;     % Stopping condition
end

% Parse MDP and reshape reward to R(x, a)

if (iscell(full(MDP.R)))
    if (length(R) ~= MDP.nA)
        error('Invalid reward function.');
    end
    
    % Reward is 3-dimensional. Reshape to 2-dimensions
    
    R = sparse(MDP.nS, MDP.nA);

    for a = 1:MDP.nA
        
        % Check reward dimensions
        
        [dim1, dim2] = size(MDP.R{a});
        
        if (dim1 ~= MDP.nS && dim2 ~= MDP.nS)
            error('Invalid reward function.');
        end
        
        % Check transition probability dimensions
        
        [dim1, dim2] = size(MDP.P{a});
        
        if (dim1 ~= MDP.nS && dim2 ~= MDP.nS)
            error('Invalid transition probabilities.');
        end

        % Average rewards (using transition probabilities)
        
        R(:, a) = sum(MDP.R{a} .* MDP.P{a}, 2);
    end

else
    
    % Reward is NOT 3-dimensional. Check whether is 2-dimensional and
    % reshape
    
    [dim1, dim2] = size(MDP.R);
    
    % Check reward dimensions
    
    if (dim1 ~= MDP.nS || (dim2 ~= 1 && dim2 ~= MDP.nA))
        error('Invalid reward function.');
    end
    
    % If 1-dimensional, expand to R(x, a), else just sparsify
    
    if (dim2 == 1)
        R = sparse(MDP.R(:, ones(1, MDP.nA)));
    else
        R = sparse(MDP.R);
    end
end

Q = zeros(MDP.nS, MDP.nA);

% Optimization setting

Qnew = zeros(MDP.nS, MDP.nA);

i = 0;
Quit = 0;

% Compute optimal Q-function using dynamic programming

while (~Quit)
    
    Qmax = max(Q, [], 2);
    
    % Value iteratation
    
    for a = 1:MDP.nA
        Qnew(:, a) = R(:, a) + MDP.Gamma * MDP.P{a} * Qmax;
    end
    
    % Check whether stopping condition is met
    
    E = max(max(abs(Q - Qnew)));
    
    if (E < MAX_ERR)
        Quit = 1;
    end
    
    Q = Qnew;
    i = i + 1;
    
end

% Compute optimal policy from optimal Q-function

Qmax = max(Q, [], 2);                           % Find maximal actions
P  = sparse( (Q - Qmax(:, ones(MDP.nA, 1))).^2 < MAX_ERR );     % "Mark" maximal actions
Psum = sum(P, 2);                               % Normalization constant
P  = spdiags(1./Psum, 0, MDP.nS, MDP.nS) * P;   % Normalize policy