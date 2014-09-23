function [combinedParamStructs, nCombination] = combine_parameters(varargin)
% Example:
%   combinedParamStructs = combine_parameters('param1', {1,2,3}, 'param2', {'e', 'r'}, 'param3', 1:2)
% Look at the result:
%   for i = 1:length(combinedParamStructs)
%       combinedParamStructs{i}
%   end

%Check the number of input arguments
if (mod(nargin, 2))
    error('Each param must be a string/cell pair.');
end

nParam = nargin/2;

paramName = cell(1, nParam);
paramElem = cell(1, nParam);
paramNumel = zeros(1, nParam);
for i = 1:nParam
    paramName{i} = varargin{(i*2)-1};
    paramElem{i} = varargin{i*2};
    paramNumel(i) = length(paramElem{i});
end

nCombination = prod(paramNumel);

%
currentParamCombination = ones(1, nParam);

combinedParamStructs = cell(nCombination, 1);
cnt = 0;
while true
    cnt = cnt + 1;
    for  i = 1:nParam
        elem = paramElem{i};
        if isnumeric(elem) || islogical(elem)
            if isvector(elem)
                value = elem(currentParamCombination(i));
            else
                value = elem{currentParamCombination(i)};
            end
        else
            value = elem{currentParamCombination(i)};
        end
        combinedParamStructs{cnt}.(paramName{i}) = value;
    end
    
    if all(currentParamCombination == paramNumel)
        break
    else
        for i = 1:nParam
            if i > 1
                if currentParamCombination(i-1) > paramNumel(i-1)
                    currentParamCombination(i-1) = 1;
                    currentParamCombination(i) = currentParamCombination(i) + 1;
                end
            else
                currentParamCombination(i) = currentParamCombination(i) + 1;
            end
        end
    end
end






