% PROGRAM TO CALCULATE TEMPERATURE TRAJECTORIES OF A DIVERSITY OF PLANETS
% 
% This program calculates the climate evolutions of a variety of different
% planets, based on a simple representation of their climate feedbacks. The
% underlying scientific question which the sinulation is designed to
% address is to understand how the Earth stayed habitable for over 3
% billion years, an immense span of time. There are several reasons for
% being surprised that it did so:
% 
% 1. a short residence time (<1 million years) of atmospheric CO2, 
%    potentially driving climate volatility;
% 2. increase in the heat received from the Sun, by more than 40% over the
%    lifespan of the Earth (hence the Faint Young Sun problem); and
% 3. prominent reminders of the ease of uninhabitability in the form of
%    Earth's nearest neighbours: Mars (too cold) and Venus (too hot).
% 
% The question is addressed here by examining the occurrence of
% habitability in a large and diverse population of planets. A large number
% of model planets are created and each allocated a random set of climate
% feedbacks. Each planet is initialised at a random temperature and then
% simulated through time to see how its temperature history develops, under
% the influence of both its feedbacks and external factors. In this way the
% model is able to evaluate whether planets are able to maintain their
% temperatures within the habitable range in the face of potentially 
% destabilising factors such as long-term forcings and perturbations.
% 
% units:
%    (1) thousands of years (ky) for time
%    (2) degrees centigrade for temperature
% 
% Matlab R2014b R2015a 
% 
% This version of the Planets model is the parallel version
% 
% You are free to use, modify and share this code according to the terms of
% this license:  https://creativecommons.org/licenses/by-nc-sa/4.0/    
%                                                      Toby Tyrrell, 2017 
%--------------------------------------------------------------------------

% this script sets up a simulation and submits it for execution
% 
% other sccripts are called to initialise the simulation, determine the 
% inherent properties of all planets, allocate runs to tasks, and submit
% those tasks to be run across a set of processors


%% initialisation
initialise_master;

% for each planet, determine its properties
for ii = 1:nplanets
    
    % Randomly initialise the climate feedbacks for this planet
    determine_feedbacks;
    
    % Randomly determine an overall tendency for progressive cooling or
    % warming (the long-term forcing or 'trend') for this planet
    determine_trend;
    
    % Randomly initialise the planet's 'neighbourhood' (expected
    % numbers of small, moderate and large perturbations)
    determine_neighbourhood;
    
    % store key planet intrinsic properties in an array
    planets(ii).nnodes = nnodes;                % number of nodes
    for qq = 1:nnodes_max
        planets(ii).Tnodes(qq) = Tnodes(qq);          % T of node
        planets(ii).Tfeedbacks(qq) = Tfeedbacks(qq);  % dT/dt of node
    end
    planets(ii).trend = trend;                  % long-term forcing
    planets(ii).lambda_big = lambda_big;        % big P freq (av number)
    planets(ii).lambda_mid = lambda_mid;        % mid P freq (av number)
    planets(ii).lambda_little = lambda_little;  % little P freq (av number)
end  % of all planets


%% parallel execution of tasks
% simulation: the whole thing, made up of one or more jobs
% job: a group of tasks
% task: a group of runs
% run: the calculated temperature evolution of one instance of one planet

% decide how to split up the whole simulation into separate tasks
task_allocation;

% set up a cluster object
ct = parcluster;

% for each job submitted to the cluster
for jj = 1 : njobs    % (if more than 1; njobs = 1 for Iridis4)
    
    % create a job to run on the cluster, but do not submit it yet
    jt = createJob(ct);
    
    % calculate the first and last tasks that will be included in this job
    taskbc = ((jj-1) * ntasksperjob) + 1;
    taskec = min((jj*ntasksperjob), ntasks);
    
    fprintf('   about to start adding tasks %d-%d to job number %d\n', ...
        taskbc, taskec, jj);
    
    % for each task in this job
    for tt = taskbc:taskec
        
        % work out how many runs are in this task (usually = ntaskruns, but
        % can be less). Each run is likely to be of a different planet
        nr = sum(~isnan(task_planets(tt,:)));
        
        % put all of the information needed to execute this task into a
        % single structure (s) ready to pass to the slave processor
        make_task_input;
        
        % create a new task object and add it to the pending job (jt)
        taskt = createTask(jt,@ts_slave,2,{s}); % input = s, 2 outputs
        
        fprintf('\nTASK NUMBER <<< %d >>> \n', tt);
    end
    
    % display the job to check that tasks were added to the job
    jt.Tasks
    
    % submit the job to the PBS batch queue
    submit(jt);
end

% finish, leaving the job running on the cluster
