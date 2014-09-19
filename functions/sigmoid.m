function Y = sigmoid(X, center, slope)
%TODO: everything
if nargin < 3
    slope = 1;
end
if nargin < 2
    center = 0;
end


Y = 1 ./ (1 + exp(- slope * (X - center)));


