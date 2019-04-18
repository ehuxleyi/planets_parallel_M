% script to analyse and plot the complete set of simulation results
% 
% this script should only be run after a simulation has been executed
% (ts_master.m) and then retrieved (ts_retrieve.m)
% 
% the simulation to be analysed is specified in "set_constants.m" by
% uncommenting the last line and replacing the directory name there with
% the directory name of the simulation to be analysed. For instance, if a
% simulation of 1000 planets each rerun 100 times was retrieved (using the
% script ts_retrieve.m) on 28 July 2017, then the results will
% automatically have been placed in the directory
% "results/1000x100_28Jul2017" and savename should be set to 
% "1000x100_28Jul2017"
% Note that the line should be commented again after running ts_analyse, to
% allow automatic name generation to work correctly next time
%--------------------------------------------------------------------------


%% initialisation

initialise_analyser;

% find the directory where the task results should all be stored
dname = sprintf('results/%s', savename);
if ~exist(dname, 'dir')
    error('  ERROR: RESULTS DIRECTORY DOES NOT EXIST: %s\n\n', dname);
end

% read in the header file and check that the expected information is in it
read_header;

fprintf('starting analyser for "%s" (%d planets, %d reruns each, in %d tasks)\n\n', ...
    svname, np, nr, nt);

fprintf('   ...looking for sets of results from different tasks...\n\n');

% check that all the task output files exist
errorfl = 0;
for tt = 1 : nt
    idd = sprintf('results/%s/task_%d.mat', savename, tt);
    if ~exist(idd, 'file')
        error('  ERROR: EXPECTED TASK OUTPUT FILE (%s) DOES NOT EXIST\n\n', idd);
        errorfl = 1;
    end
end


%% read in the whole set of results

fprintf('   ...found all %d sets of task results, now reading them in...\n\n', nt);

% if all files are there then read them all in and transfer their results
% to the complete array for the whole simulation
if (errorfl == 0)
    for tt = 1 : nt    % for each task
        idd = sprintf('results/%s/task_%d', savename, tt);
        load(idd); % should read savename, task_number, pl, tp, rl and tr
        savename = svname;
        if (tt ~= task_number)
            error('  ERROR: TASK NUMBERS DO NOT AGREE (%d) (%d)\n\n', ...
                tt, task_number);
        end
        array_transfers;    % transfer in the task results
        fprintf('have read in data from task number %d\n', tt);
    end
end

% check that the whole of the results arrays have been populated
for aa = 1 : nplanets
    if (isnan(planets(aa).pnumber) || isnan(planets(aa).nnodes) || ...
            (planets(aa).nnodes < 2))
        error('  ERROR: PLANET (%d) has no data\n\n', aa);
    end
end
for bb = 1 : nruns
    if (isnan(runs(bb).runnumber) || isnan(runs(bb).result) || ...
            (runs(bb).result < -1) || (runs(bb).result > 1))
        error('  ERROR: RUN (%d) has no data\n\n', bb);
    end
end


%% analyse the complete set of results

fprintf('   ...analysing the complete simulation results...\n\n');

% now that have the whole simulation results all in one, go through them
% and fill in any missing numbers (mainly planet statistics) and calculate
% statistics over whole planets (which could have been run over two or more
% tasks) and the whole population

ngoodruns = 0;          % counter for number of successful runs
ntoohot = 0;            % counter for number of runs becoming too hot
ntoocold = 0;           % counter for number of runs becoming too cold

% for each planet
for ii = 1:nplanets
    
    nsurvived = 0;      % counter for number of successful reruns
    ndied = 0;          % counter for number of failed reruns
    sumduration = 0.0;  % tally for calculating average rerun duration
    
    % for each rerun
    for jj = 1:nreruns
        
        runnumber = (ii-1)*nreruns + jj;
        
        % increment counters for planets surviving or dying, also how many
        % got too cold and how many got too hot.
        % result of 1 means survived, 0 means got too hot and -1 too cold       
        if (runs(runnumber).result == 1)
            nsurvived = nsurvived + 1;
            ngoodruns = ngoodruns + 1;
        else
            ndied = ndied + 1;
            if (runs(runnumber).result == 0)   % too hot
                ntoohot = ntoohot + 1;
            elseif (runs(runnumber).result == -1)   % too cold
                ntoocold = ntoocold + 1;
            end
        end
        sumduration = sumduration + runs(runnumber).length;
    end  % of all reruns of the same planet
    
    % calculate success statistics (incl. proportion of runs that went
    % the full distance) for this planet
    planets(ii).nsuccess = nsurvived;
    planets(ii).nfail = ndied;
    if (nsurvived > 0)
        planets(ii).any_survived = 1;
    else
        planets(ii).any_survived = 0;
    end
    planets(ii).successrate = nsurvived / nreruns;
    planets(ii).avduration = round(sumduration) / nreruns / 1e6;
    
    if (nsurvived > 0)
        ngoodplanets = ngoodplanets + 1;
    end

end  % of all planets

% plot histograms and other plots, to help understand how the probability
% of a planet surviving is influenced by various factors
plot_final_results;

% calculate summary information and statistics
summary;
