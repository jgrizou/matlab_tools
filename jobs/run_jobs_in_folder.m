function run_jobs_in_folder(folderName, waitingTime)

addpath(genpath(folderName));

jobFolder = fullfile(folderName, 'wait_jobs');
runFolder = fullfile(folderName, 'run_jobs');
endFolder = fullfile(folderName, 'end_jobs');

run_jobs(jobFolder, runFolder, endFolder, waitingTime)