function ensure_new_folder(folderName)
%ENSURE_NEW_FOLDER

if ~exist(folderName, 'dir')
    mkdir(folderName)
end

