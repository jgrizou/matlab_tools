function nWaiting = waiting_jobs_in_folder(folderName)

[pathstr, ~, ~] = fileparts(mfilename('fullpath'));
jobFolder = fullfile(pathstr, folderName, 'wait_jobs');
waitingJobs = getfilenames(jobFolder, 'refiles', '*.m');
nWaiting = length(waitingJobs);


