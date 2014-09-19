function theta = train_logistic_regression(X, y, lambda, optioptions)

if nargin < 4
    optioptions = optimset('GradObj', 'on', 'MaxIter', 100,'Diagnostics', 'off', 'Display','off');
end

%y should be of two class one of 0 the other of 1

%add a column of 1
X = [ones(size(X,1),1), X];

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

% Optimize
theta = fminunc(@(t)(cost_logistic_regression(t, X, y, lambda)), initial_theta, optioptions);