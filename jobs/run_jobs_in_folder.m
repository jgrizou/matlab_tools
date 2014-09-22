function run_jobs_in_folder(folderName, waitingTime)

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(pathstr, folderName)));

jobFolder = fullfile(pathstr, folderName, 'wait_jobs');
runFolder = fullfile(pathstr, folderName, 'run_jobs');
endFolder = fullfile(pathstr, folderName, 'end_jobs');

run_jobs(jobFolder, runFolder, endFolder, waitingTime)


