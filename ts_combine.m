% script to combine the results of several jobs into one
% 
% larger simulations need to be executed in parts. The results are combined
% using this script and then re-saved as a single, complete set of results
% -------------------------------------------------------------------------

set_constants;

% don't use some of the values in set_constants
clear savename nplanets nreruns nruns;

% directories where results are to be taken from 
places = {'1st_40x20_I4_v2' '2nd_40x20_I4_v2' '3rd_40x20_I4_v2' ...
    '4th_40x20_I4_v2' '5th_40x20_I4_v2'};
number_reruns = 20;
% directory where combined results are to be placed
dest = '200x20_I4_v2_combined';


%% first check through the directories where the results of each part
% should be stored, in order to check that everything is there and in
% order. Also in order to find out how many planets and runs there are in
% total, in order to know the size of the arrays to set up
for ii = 1:length(places)
    
    dirname = char(places(ii));
    
    dname = sprintf('results/%s', dirname);
    if ~exist(dname, 'dir')
        fprintf('  ERROR: RESULTS DIRECTORY DOES NOT EXIST: %s\n\n', dname);
    end
    
    % read in the header file and check that the expected information is in it
    hname = sprintf('%s/header.mat', dname);
    if ~exist(hname, 'file')
        fprintf('  ERROR: NO HEADER (%s)\n\n', hname);
    else
        load(hname);   % should read in svname, np, nr, nt
        if (svname ~= dirname)
            fprintf('  ERROR: SIMULATION NAMES DO NOT AGREE (%s) (%s)\n\n', ...
                svname, dirname);
        end
        if (nr ~= number_reruns)
            fprintf('  ERROR: NUMBERS OF RUNS DO NOT AGREE (%d) (%d)\n\n', ...
                nr, number_reruns);
        end
    end
    
    fprintf('starting combiner for "%s" (%d planets, %d reruns each, in %d tasks)\n\n', ...
        svname, np, nr, nt);
    
    comb_np(ii) = np;
    comb_nr(ii) = nr;
    comb_nt(ii) = nt;
    
    fprintf('   ...looking for sets of results from different tasks...\n\n');
    
    % check that all the task output files exist
    errorfl = 0;
    for tt = 1 : nt
        idd = sprintf('results/%s/task_%d.mat', dirname, tt);
        if ~exist(idd, 'file')
            fprintf('  ERROR: EXPECTED TASK OUTPUT FILE (%s) DOES NOT EXIST\n\n', idd);
            errorfl = 1;
        end
    end
end

% check that there is the same number of reruns in all
for ii = 2:length(places)
    if (comb_nr(ii) ~= comb_nr(1))
        fprintf('  ERROR: NUMBERS OF RUNS DO NOT AGREE BETWEEN COMBINED FILES (%d and %d)\n\n', ...
            comb_nr(1), comb_nr(ii));
    end
end
nreruns = comb_nr(1);


%% initialisation

% calculate the total number of planets and runs and tasks
nplanets = sum(comb_np);
nruns = nplanets * nreruns;
total_nt = sum(comb_nt);

% initialise arrays
Tnodes = double(zeros([1 nnodes_max]));     % T at each node
Tfeedbacks = double(zeros([1 nnodes_max])); % feedback (dT/dt) at each node
Tinits = double(zeros([nplanets nreruns])); % initial temperatures
attractors = double(zeros([nnodes_max 14]));  % cannot be more attractors than nodes
attr       = double(zeros([nnodes_max 14]));

% set up structures and arrays to store information about each planet in
% the whole simulation, to be used in later analysis
for pp = 1:nplanets
    planets(pp).pnumber = NaN;        % number (id) of the planet
    planets(pp).nnodes = NaN;         % number of nodes
    planets(pp).nattractors = NaN;    % number of stable attractors
    planets(pp).trend = NaN;          % heating or cooling trend
    %     - including stable attractor properties of the planet
    planets(pp).max_attr_width = NaN;    % width of widest one
    planets(pp).max_attr_height = NaN;   % height of highest one
    planets(pp).max_attr_strength = NaN; % strength of strongest one
    planets(pp).max_attr_power = NaN;    % power of most powerful one
    planets(pp).max_attr_pos1 = NaN;     % position of most powerful one
    planets(pp).max_attr_dist1 = NaN;    % distance of most powerful one from centre of habitable range
    planets(pp).max_attr_pos2 = NaN;     % position of most powerful one
    planets(pp).max_attr_dist2 = NaN;    % distance of most powerful one from centre of habitable range
    %     - and other properties
    planets(pp).pcrunaway = NaN;    % percentage of temperature range susceptible to runaway feedbacks
    planets(pp).asymmetry = NaN;    % asymmetry of feedbacks
    %     - and statistics about results (performance of this planet)
    planets(pp).nsuccess = NaN;     % number of successful runs
    planets(pp).nfail = NaN;        % number of failed runs
    planets(pp).any_survived = NaN; % whether successful in any run (0 or 1)
    planets(pp).successrate = NaN;  % fraction of successful runs
    planets(pp).avduration = NaN;   % average time to failure
    for qq = 1:nnodes_max
        planets(pp).Tnodes(qq) = NaN;         % T of node
        planets(pp).Tfeedbacks(qq) = NaN;     % dT/dt of node
    end
end

% set up structures and arrays to store information about each run in the
% whole simulation, to be used in later analysis
for rr = 1:nruns
    runs(rr).planetnumber = NaN;       % number of the planet
    runs(rr).rerunnumber = NaN;        % which rerun it is
    runs(rr).runnumber = NaN;          % number of the run
    runs(rr).result = NaN;             % outcome of run (whether it stayed habitable for 3 By or not)
    runs(rr).length = NaN;             % how long it lasted for
    runs(rr).max_potential_perturbation = NaN; % magnitude of largest 'kick' if continued for 3 By
    runs(rr).max_actual_perturbation = NaN;   % magnitude of largest actual 'kick'
    runs(rr).Tinit = NaN;              % starting temperature
    runs(rr).standard_deviation = NaN; % standard deviation of T during run
    runs(rr).Ttrend = NaN;             % observed trend over time of T during run
    runs(rr).Tmode = NaN;              % mode (most frequent) T during run
    runs(rr).frtime_in_sas = NaN;      % fraction of time during run spent within stable attractor limits
    runs(rr).frtime_elsewhere = NaN;   % fraction of time during run spent outside stable attractor limits
    runs(rr).frtime_mostpowerful_sa = NaN;  % fraction of time during run spent within the limits of the most powerful stable attractor limits
    runs(rr).frtime_mostoccupied_sa = NaN;  % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
    runs(rr).pos_mostocuupied_sa = NaN;     % position of the most occupied stable attractor
end


%% now go through all of the parts, reading in the results from each of the
% directories

fprintf('Found all %d sets of task results in %d directories, now reading them in\n\n', ...
    total_nt, length(places));

prev_pl = 0;  % number of planets already read in from previous directories
prev_runs = 0;  % number of runs already read in from previous directories
% for each part
for ii = 1:length(places)
    
    dirname = char(places(ii));
    dname = sprintf('results/%s', dirname);
    
    % if all files are there then read them all in and transfer their results
    % to the arrays for the whole simulation
    nt = comb_nt(ii);
    % for each task
    for tt = 1 : nt
        
        % read in task results
        idd = sprintf('results/%s/task_%d', dirname, tt);
        load(idd); % should read savename, task_number, , pl, tp, rl and tr
        if (tt ~= task_number)
            fprintf('  ERROR: TASK NUMBERS DO NOT AGREE (%d) (%d)\n\n', ...
                tt, task_number);
        end
        
        % for each planet in this task, transfer it across from the task
        % array into the overall array
        
        % for each planet in this task
        for tpc = 1 : length(pl)  % index of a planet in the task array
            
            % index of the planet in the total combined array
            if (ii == 1)
                pp = tp(tpc).pnumber;
            else
                pp = tp(tpc).pnumber + prev_pl;
            end
                    
            % now transfer
            planets(pp).pnumber = pp;      % number of this planet
            planets(pp).nnodes  = tp(tpc).nnodes;   % number of nodes
            planets(pp).nattractors = tp(tpc).nattractors; % number of stable attractors
            for qq = 1:nnodes_max
                planets(pp).Tnodes(qq) = NaN;
                planets(pp).Tfeedbacks(qq) = NaN;
            end
            for qq = 1:tp(tpc).nnodes
                planets(pp).Tnodes(qq) = tp(tpc).Tnodes(qq);  % T of each node
                planets(pp).Tfeedbacks(qq) = tp(tpc).Tfeedbacks(qq);% dT/dt of each node
            end
            planets(pp).trend = tp(tpc).trend;   % heating or cooling trend
            planets(pp).max_attr_width = tp(tpc).max_attr_width;
            planets(pp).max_attr_height = tp(tpc).max_attr_height;
            planets(pp).max_attr_strength = tp(tpc).max_attr_strength;
            planets(pp).max_attr_power = tp(tpc).max_attr_power;
            planets(pp).max_attr_pos1 = tp(tpc).max_attr_pos1;
            planets(pp).max_attr_dist1 = tp(tpc).max_attr_dist1;
            planets(pp).max_attr_pos2 = tp(tpc).max_attr_pos2;
            planets(pp).max_attr_dist2 = tp(tpc).max_attr_dist2;
            planets(pp).pcrunaway = tp(tpc).pcrunaway;
            planets(pp).asymmetry = tp(tpc).asymmetry;
        end
        
        % for each run in this task, transfer it across from the task array
        % to the overall array
        
        % for each run in this task
        for tpr = 1 : (length(rl)*length(pl))  % index of a run in the task array
            
            % now calculate the index of the planet and the run in the
            % total combined array
            if (ii == 1)
                rr = tr(tpr).runnumber;
                pp = tr(tpr).planetnumber;
            else
                rr = tr(tpr).runnumber + prev_runs;
                pp = tr(tpr).planetnumber + prev_pl;
            end
            
            runs(rr).planetnumber = pp;                         % number of the planet
            runs(rr).rerunnumber = tr(tpr).rerunnumber;         % which rerun it is
            runs(rr).runnumber = rr;                            % number of the run
            runs(rr).result = tr(tpr).result;                   % outcome of run (whether it stayed habitable for 3 By or not)
            runs(rr).length =  tr(tpr).length;                  % how long it lasted for
            runs(rr).max_potential_perturbation = tr(tpr).max_potential_perturbation;  % magnitude of largest 'kick' if continued for 3 By
            runs(rr).max_actual_perturbation = tr(tpr).max_actual_perturbation; % magnitude of largest actual 'kick'
            runs(rr).Tinit = tr(tpr).Tinit;                     % starting temperature
            runs(rr).standard_deviation = tr(tpr).standard_deviation;  % standard deviation of T during run
            runs(rr).Ttrend =  tr(tpr).Ttrend;                  % observed trend over time of T during run
            runs(rr).Tmode = tr(tpr).Tmode;                     % mode (most frequent) T during run
            runs(rr).frtime_in_sas = tr(tpr).frtime_in_sas;     % fraction of time during run spent within stable attractor limits
            runs(rr).frtime_elsewhere = tr(tpr).frtime_elsewhere;              % fraction of time during run spent outside stable attractor limits
            runs(rr).frtime_mostpowerful_sa = tr(tpr).frtime_mostpowerful_sa;  % fraction of time during run spent within the limits of the most powerful stable attractor limits
            runs(rr).frtime_mostoccupied_sa = tr(tpr).frtime_mostoccupied_sa;  % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
            runs(rr).pos_mostocuupied_sa = tr(tpr).pos_mostocuupied_sa;        % position of the most occupied stable attractor
        end
    end
    
    prev_pl = prev_pl + comb_np(ii);
    prev_runs = prev_runs + comb_np(ii)*comb_nr(ii);
end


%% check that the arrays for the whole simulaation have been filled
for aa = 1 : nplanets
    if (isnan(planets(aa).pnumber) || isnan(planets(aa).nnodes) || ...
            (planets(aa).nnodes < 2))
        fprintf('  ERROR: PLANET (%d) has no data\n\n', aa);
    end
    for bb = 1 : nruns
        if (isnan(runs(bb).runnumber) || isnan(runs(bb).result) || ...
                (runs(bb).result < -1) || (runs(bb).result > 1))
            fprintf('  ERROR: RUN (%d) has no data\n\n', bb);
        end
    end
end


%% now that have the whole simulation results all in one, analyse them.
% fill in any missing numbers (mainly planet statistics) - calculate
% statistics over all of each planet's reruns (which could have been
% executed in two or more tasks) and the whole population

fprintf('   have read in the combined simulation results...\n\n');
fprintf('   ...analysing the complete simulation results...\n\n');

ngoodplanets = 0;

% for each planet in the whole simulation
for ii = 1:nplanets
  
    nsurvived = 0;             % counter for number of successful runs
    ndied = 0;                 % counter for number of failed runs
    sumduration = 0.0;         % counter for calculating average run duration
    
    % for each of the planet's reruns
    for jj = 1:nreruns
        
        runnumber = (ii-1)*nreruns + jj;
        
        % increment counters for planets surviving or dying
        if (runs(runnumber).result == 1)
            nsurvived = nsurvived + 1;
        else
            ndied = ndied + 1;
        end
        sumduration = sumduration + runs(runnumber).length;
    end  % of all reruns of the same planet
    
    % calculate success statistics (incl. proportion of runs that went
    % full distance) for this planet
    planets(ii).nsuccess = nsurvived;
    planets(ii).nfail = ndied;
    if (nsurvived > 0)
        planets(ii).any_survived = 1;
    else
        planets(ii).any_survived = 0;
    end
    planets(ii).successrate = nsurvived / nreruns;
    planets(ii).avduration = round(sumduration*1e6);
    planets(ii).avduration = planets(ii).avduration / nreruns / 1e6;
    
    if (nsurvived > 0)
        ngoodplanets = ngoodplanets + 1;
    end
    
    % summarise results over all reruns of this planet
    if ((nsurvived+ndied) ~= nreruns)
        fprintf ('***WARNING*** error for planet %d (%d reruns, %d remained habitable, %d went sterile)\n\n', ...
            ii, nreruns, nsurvived, ndied);
    end
    fprintf ('\nPLANET #%d SUMMARY: of %d reruns, %d remained habitable, %d went sterile\n', ...
        ii, nreruns, nsurvived, ndied);
    fprintf ('\n                    average survival time was %.2f\n\n\n', ...
        (sumduration/nreruns));

end  % of all planets

% summarise results over all planets
fprintf ('OVERALL SUMMARY: %d out of %d planets survived at least once (%d reruns each)\n', ...
    ngoodplanets, nplanets, nreruns);

% save the combined results to the new directory, then plot them
savename = dest;
destname = sprintf('results/%s', dest);
mkdir(destname);
plot_final_results;
