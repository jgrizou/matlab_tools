function p = predict_logistic_regression(X, theta) 
X = [ones(size(X,1),1), X];
p = sigmoid(X * theta);

