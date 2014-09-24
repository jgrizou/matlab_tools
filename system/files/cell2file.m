function cell2file(fileName, stringCell)
%CELL2FILE
% this function take a cell of string and parse if into a file. Each cell element is one ligne

fid = fopen(fileName, 'w');
for i = 1:length(stringCell)
    fprintf(fid, stringCell{i});
    fprintf(fid, '\n');
end
fclose(fid);