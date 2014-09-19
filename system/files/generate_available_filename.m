function filename = generate_available_filename(folder, extension, nChar)
%GENERATE_FREE_FILENAME
if nargin < 3
    nChar = 10; %default filename length is 10
end
if nargin < 2
   extension = '.mat';
end
if nargin < 1
   folder = ''; 
end
if ~isdir(folder) && ~strcmp(folder, '')
    warning('get_free_filename:InvalidFolder', ['"', folder, '" folder does not exist'])
end
if ~strcmp(extension(1), '.')
   extension = ['.', extension]; 
end
symbols = ['a':'z' 'A':'Z']; %no number here because m files strating with number are not recognize!
nums = randi(numel(symbols),[1 nChar]);
filename = fullfile(folder, [symbols(nums), extension]);
if exist(filename, 'file')
    filename = generate_available_filename(folder, extension, nChar);
    %yes this will crash if no more file are available or if maximum recursion limit reached
    %so use more char than necessary to ensure the recursive call is an exception
end