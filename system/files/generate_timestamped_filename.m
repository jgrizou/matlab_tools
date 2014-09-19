function filename = generate_timestamped_filename(folder, extension)
%GENERATE_TIMESTAMPED_FILENAME
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
filename = datestr(now,'HH_MM_SS_FFF_dd_mmmm_yyyy');
filename = fullfile(folder, [filename, extension]);
if exist(filename, 'file') % very very unlikely
    filename = generate_timestamped_filename(folder, extension);
end