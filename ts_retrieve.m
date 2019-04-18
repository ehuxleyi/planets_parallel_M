% script to retrieve results once all tasks have been executed
% 
% The cluster or workstation is interrogated to see if a job has finished.
% If so then the results are retrieved and saved.
%--------------------------------------------------------------------------


%% initialisation
initialise_retriever;

% calculate information about the tasks and initialise arrays in which to
% put the results
task_allocation;

% set up a cluster object
ct = parcluster;

% see if there are any completed jobs
[pending queued running completed] = findJob(ct);
myjobs = findJob(ct);

if isempty(pending)
    fprintf('no jobs pending\n');
else
    fprintf('%d jobs are pending\n', length(pending));
    pending
end
if isempty(queued)
    fprintf('no jobs queued\n');
else
    fprintf('%d jobs are queued\n', length(queued));
    queued
end
if isempty(running)
    fprintf('no jobs running\n');
else
    fprintf('%d jobs are running\n', length(running));
    running
end
if isempty(completed)
    fprintf('no jobs completed\n');
    finished_flag = 0;
else
    fprintf('%d jobs are completed\n', length(completed));
    completed
    finished_flag = 1;
end

% only try and retrieve the results if one or more jobs have finished
if (finished_flag == 1)
    
    % for each finished job
    for kkk = 1:length(completed)
        
        % delete any previous results to make sure no unintentional carryover
        clear idd tpout trout task_number pl tp rl tr;
        
        % retrieve the results from all of the tasks in this job
        jobres = fetchOutputs(completed(kkk));
        
        % calculate the first and last numbers of the tasks that were
        % included in this job
        taskbc = ((kkk-1) * ntasksperjob) + 1;
        taskec = min((kkk*ntasksperjob), ntasks);
        
        % extract the results from each task and transfer to a structure.
        % note that the tasks overall are numbered from 1 to ntasks, but in
        % each job are numbered from taskbc to taskec. To avoid
        % duplication, saved matfiles need to correspond to the overall
        % task number, not to its number within the individual job
        for tt = 1:(1+taskec-taskbc)
            
            % overall task number
            tto = taskbc + tt - 1;
            
            fprintf('transferring task %d results to a structure\n', tto);
            
            % get this task's results (array of planets's properties plus
            % array of runs's properties)
            % **NOTE**: have to access using {} in order to return the
            % actual structures. Accessing using () returns instead a 1x1
            % cell array holding the structures
            tpout = jobres{tt,1};
            trout = jobres{tt,2};
            
            % work out how many runs are in this task (usually = ntaskruns,
            % but can be less). Each run is likely to be of a different
            % planet
            nr = sum(~isnan(task_planets(tto,:)));
            
            % prepare information to be saved into matfile
            if (length(completed) == 1)
                idd = sprintf('results/%s/task_%d', savename, tto);
            elseif (length(completed) > 1)
                idd = sprintf('results/%s/job%d_task_%d',savename,kkk,tto);
            end
            task_number = tto;   % overall task number
            pl = [task_planets(tto,1:nr)]; % list of planets
            tp = tpout;   % array of planets' properties
            rl = [task_runs(tto,1:nr)]; % list of runs
            tr = trout;   % array of runs' properties
            
            fprintf('saving task %d results to a matfile\n', tto);
            
            save (idd, 'savename', 'task_number', 'pl', 'tp', 'rl', 'tr');
        end
               
        % save a header file to the results directory
        hname = sprintf('results/%s/header.mat', savename);
        svname = savename; np = nplanets; nr = nreruns; nt = ntasks;
        save (hname, 'svname', 'np', 'nr', 'nt');
    end   % of finished jobs
    
else
    fprintf('\n     Exiting because no completed runs to retrieve results from\n\n');   
end
