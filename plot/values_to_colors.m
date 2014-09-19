function mapped_colors = values_to_colors(values, limMinMax, cmap)
%VALUES_TO_COLORS 
if nargin < 2
    limMinMax = [min(values), max(values)];
end
if nargin < 3
    cmap = jet(10000);
end
mapped_values = ((values - limMinMax(1)) / (limMinMax(2) - limMinMax(1)));
mapped_values(isnan(mapped_values)) = mean(limMinMax); % happens mostly when values are all the sames
mapped_values(mapped_values < 0) = 0;
mapped_values(mapped_values > 1) = 1;
mapped_values = round(mapped_values * (size(cmap, 1) - 1)) + 1;
mapped_colors = cmap(mapped_values, :);

