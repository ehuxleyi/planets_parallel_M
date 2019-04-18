% script to calculate and plot results from the whole simulation 
% 
% Other scripts are called to calculate frequency distributions and
% various other statistics and then to plot histograms and other plots to
% give insight into the numbers of successful runs and planets and their
% probabilistic relationship to different properties.
% -------------------------------------------------------------------------


%% create lists of all successful planets (those which stayed habitable on
% at least one of their reruns) and runs, and count numbers of successes
ngoodruns = 0;
nhabplanets = 0;
nperfectplanets = 0;
goodplanets = zeros([1 nplanets]);

% for each planet
for pp = 1:nplanets
    
    a_run_survived = 0;
    all_runs_survived = 1;
    
    % for each rerun of that planet
    for kk = 1:nreruns
        rr = (pp-1)*nreruns+kk;
        % if the run was successful (remained habitable)...
        if (runs(rr).result == 1)
            % set a flag to show that this planet had at least one
            % successful run
            a_run_survived = 1;
            % copy this run to the list of successful runs
            ngoodruns = ngoodruns + 1;
            goodruns(ngoodruns) = runs(rr);
        else
            all_runs_survived = 0;
        end
    end
    
    % if at least one instance of this planet survived...
    if (a_run_survived == 1)
        planets(pp).any_survived = 1;
        % copy this planet to the list of successful planets
        nhabplanets = nhabplanets + 1;
        goodplanets(nhabplanets) = pp;
    else
        planets(pp).any_survived = 0;
    end
    
    % if all instances of this planet survived...
    if (all_runs_survived == 1)
        planets(pp).all_survived = 1;
        nperfectplanets = nperfectplanets + 1;
    else
        planets(pp).all_survived = 0;
    end
end


%% calculate frequency distributions and ratios
% split the range of each property up into 20 bins (or whatever number is
% specified) and calculate frequencies of occurrence of each of those bins

% first for the properties of planets
calc_planet_freqs;
% then for the properties of runs
calc_run_freqs;


%% generate all the plots 

fprintf('   ...plotting the complete simulation results...\n\n');

% if they do not already exist, create directories to save the figures in
sname = ['results/' savename];
if ~exist([sname '/pngs'], 'dir')
    mkdir([sname '/pngs']);
end
if ~exist([sname '/figs'], 'dir')
    mkdir([sname '/figs']);
end

% histograms do not begin to resemble the underlying probability
% distribution functions if N is too small. Likewise, other plots are
% unreliable for small N
if ((nplanets*nreruns) > 100)
    plot_run_histograms;
end
if (nplanets > 100)
    plot_planet_histograms;
    plot_successrates;
end


%% save plots and workspace

% save all the figures
h = get(0,'children');
h = sort(h);
for ii=1:length(h)
    if (findstr(version,'R2014b') > 0)
        hnum = h(ii).Number;
    elseif (findstr(version,'R2015') > 0)
        hnum = h(ii).Number;
    elseif (findstr(version,'R2016') > 0)
        hnum = h(ii).Number;
    else
        hnum = h(ii);
    end
    saveas(h(ii), [sname '/pngs/figure' int2str(hnum)], 'png');
    saveas(h(ii), [sname '/figs/figure' int2str(hnum)], 'fig');
end

% save everything (all arrays, structures and other variables), except the
% figures, to a matfile 
allvars = whos;
tosave = cellfun(@isempty, regexp({allvars.class}, ...
    '^matlab\.(ui|graphics)\.'));
save([sname '/workspace_dump.mat'], allvars(tosave).name);
