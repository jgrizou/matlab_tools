function [bh, ph] = cboxplot(dataCells, boxplotargs, outliersargs, medianargs, patchargs, legendargs)

% not really advanced function

% dataCells is a cell array of data for each category to box plot
% each cell contains"
% - values : an array of corresponding values
% - name : the name of the category
% - color : the color to display
% - legendNames : (optinal) name for the legend might be different than name

% data1 = {};
% data1.values = rand(1500,1);
% data1.name = 'data1';
% data1.color = get_nice_color('r');
% data1.legendName = 'method1';
% 
% data2 = {};
% data2.values = rand(1,100)+1;
% data2.name = 'data2';
% data2.color = get_nice_color('g');
% data2.legendName = 'method2';
% 
% data3 = {};
% data3.values = rand(1,100);
% data3.name = 'data3';
% data3.color = get_nice_color('b');
% data3.legendName = 'method3';
% 
% dataCells = {};
% dataCells{end+1} = data1;
% dataCells{end+1} = data2;
% dataCells{end+1} = data3;
% 
% 
% boxplotargs = {'symbol', 'x'};
% outliersargs =  {'MarkerEdgeColor', [0.4,0.4,0.4], 'MarkerSize', 5};
% medianargs = {'Color', [0,0,0], 'LineWidth', 2};
% patchargs = {};
% legendargs = {'Location', 'BO'};
% 
% [bh, ph] = cboxplot(dataCells, boxplotargs, patchargs, legendargs);

nCategory = length(dataCells);

boxplotValues = [];
boxplotNames = {};
boxplotColors = [];
boxplotLegendNames = {};

for iElem = 1:nCategory
   
    nValues = length(dataCells{iElem}.values);
    valuesToAdd = reshape(dataCells{iElem}.values, nValues, 1);
    boxplotValues = [boxplotValues; valuesToAdd];
        
    boxplotNames = [boxplotNames; repmat({dataCells{iElem}.name}, nValues, 1)];
       
    boxplotColors = [boxplotColors; dataCells{iElem}.color];
    
    if isfield(dataCells{iElem}, 'legendName')
        boxplotLegendNames = [boxplotLegendNames; {dataCells{iElem}.legendName}]; 
    else
        boxplotLegendNames = [boxplotLegendNames; {dataCells{iElem}.name}]; 
    end

end

%%  plot
hold on
bh = boxplot(boxplotValues, boxplotNames, 'notch', 'on', boxplotargs{:});

boxId = 5;
ph = [];
for iElem = 1:nCategory
    X = get(bh(boxId, iElem), 'XData');
    Y = get(bh(boxId, iElem), 'YData');
    ph(end+1) = patch(X, Y, boxplotColors(iElem, :), 'FaceColor', boxplotColors(iElem, :), patchargs{:});
    plot([X(1), X(6)], [Y(1), Y(6)], 'k')
end

set(findobj(bh, 'Tag', 'Median'), medianargs{:})

set(findobj(bh, 'Tag', 'Outliers'), outliersargs{:})

legend(ph, boxplotLegendNames, legendargs{:})