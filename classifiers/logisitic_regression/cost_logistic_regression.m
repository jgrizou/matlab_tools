function [J, grad] = cost_logistic_regression(theta, X, y, lambda)

m = length(y); % number of training examples

J = (- sum( y .* log(sigmoid(X*theta)) + (1-y) .* log(1-sigmoid(X*theta))) / m ) + (lambda / (2*m)) * sum(theta(2:end).^2);

grad = zeros(size(theta));
grad(1) = ((sigmoid(X*theta)-y)' * X(:,1) ) / m ; 
grad(2:end) = ((sigmoid(X*theta)-y)' * X(:,2:end) + lambda .* theta(2:end)' ) / m ; 

