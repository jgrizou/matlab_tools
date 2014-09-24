function run_jobs(jobFolder, runFolder, endFolder, waitingTime)
%RUN_JOBS

if ~exist(jobFolder, 'dir')
    mkdir(jobFolder)
end
addpath(jobFolder);

if ~exist(runFolder, 'dir')
    mkdir(runFolder)
end
addpath(runFolder);

if ~exist(endFolder, 'dir')
    mkdir(endFolder)
end
addpath(endFolder);

while true
    jobFiles = getfilenames(jobFolder, 'refiles', '*.m');
    disp([num2str(length(jobFiles)), ' jobs remaining'])
    if ~isempty(jobFiles)    
        jobF = jobFiles{randi(length(jobFiles))};
        [~,name, ~] = fileparts(jobF);
        %
        disp(['Waiting to ensure file not in use ', name])
        pause(waitingTime)
        if exist(jobF, 'file')
            disp(['Waiting to move file ', name])
            pause(randi(waitingTime))
            try
                runJobF = fullfile(runFolder, [name, '.m']);
                movefile(jobF, runJobF)
                pause(1)
                disp(['Running ', name])
                run(runJobF)
                %
                endJobF = fullfile(endFolder, [name, '.m']);
                movefile(runJobF, endJobF)
                pause(1)
            catch err
                disp(err)
            end
        end
    else
        disp('No job available, exiting...')
        break
    end
    disp(' ')
end


