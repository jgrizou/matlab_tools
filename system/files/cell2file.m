function cell2file(finaleName, stringCell)
%CELL2FILE
% this function take a cell of string and parse if into a file. Each cell element is one ligne

fid = fopen(finaleName, 'w');
for i = 1:length(stringCell)
    fprintf(fid, stringCell{i});
    fprintf(fid, '\n');
end
fclose(fid);