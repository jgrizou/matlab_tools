function h = scatterpie(X, Y, values, colors, radius, varargin)
%SCATTERPIE 

nPoint = size(values, 1); 
nClass = size(values, 2);

h = zeros(nPoint, nClass);
for iPoint = 1:nPoint
    h(iPoint, :) = piedot(X(iPoint), Y(iPoint), values(iPoint, :), colors, radius, varargin{:});
end
