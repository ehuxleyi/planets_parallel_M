% script to set the values of constants used in the simulation
%--------------------------------------------------------------------------

global rndmode nplanets nreruns max_duration Tmin Tmax Trange nnodes_max
global fsd fmin fmax frange trendsd trendmin trendmax trendrange nbinsd 

% set values of flag for random numbers:  '1' = truly random, 
% '2' = deterministically random (same every run)
rndmode = 1;

% define constants
nplanets = 1000;           % number of distinct planets
nreruns = 10;              % number of times each planet is rerun
nruns = nplanets*nreruns;  % total number of runs to carry out
ntaskruns = 250;            % max number of runs per task [choose so as ntasks=200]
maxntasks = ceil(2*nreruns/ntaskruns); % max number of tasks in simulation
ntasksperjob = 200;        % max number of tasks per job
njobs = ceil(nruns/(ntaskruns*ntasksperjob)); % the number of jobs needed for the whole simulation
ntasks = ceil(nruns/ntaskruns); % actual number of tasks in the simulation
max_duration = 3e6;        % length of run: 3 billion y = 3 million ky
Tmin = double(-10.0);      % min habitable temperature (lower T limit) (degrees C)
Tmax = double(60.0);       % max habitable temperature (upper T limit) (degrees C)
Trange = Tmax-Tmin;        % width of habitable envelope (degrees C)
nnodes_max = 20;           % max number of node points at which dT/dt needs to be specified
fsd = 100.0;               % standard deviation of feedback strengths (degrees C per ky)
fmax = +4 * fsd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fmin = -4 * fsd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
frange = 2 * fsd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
trendsd = 50.0;            % standard deviation of trends in dT/dt (degrees C per ky per By)
trendmax = +4 * trendsd;   % maximum likely trend in dT/dt (degrees C per ky per By)
trendmin = -4 * trendsd;   % minimum likely trend in dT/dt (degrees C per ky per By)
trendrange = 2*4*trendsd;  % range of likely trend values (+/- 4 sigma) (degrees C per ky per By)
nbinsd = 20;               % default number of bins for the histograms

% parameters controlling numbers of 3 different classes of perturbations.
% These numbers are the maximum average numbers, i.e. the largest expected
% values, i.e. the values corresponding to those neighbourhoods in which
% there is the greatest frequency of perturbations
maxavnumber_littlep = 20000;
maxavnumber_midp = 400;
maxavnumber_bigp = 5;
% parameters controlling magnitudes of 3 different classes of perturbations
littlep_mean = 2.0;
littlep_std = 1.0;
midp_mean = 8.0;
midp_std = 4.0;
bigp_mean = 32.0;
bigp_std = 16.0;
% likely upper limit on magnitude of largest perturbation (99.994% of a
% normal distribution lies within +/- 4 standard deviations) 
exp_pmax = bigp_mean+(4.0*bigp_std);

% when saving result from a simulation, automatically construct a results
% directory name from the date, size and a stub indicating the platform on
% which it is run
str = datestr(now);
savename = sprintf('%dx%d_%s%s%s', nplanets, nreruns, ...
    str(1:2), str(4:6), str(8:11));
% alternatively, when obtaining results in order to analyse them, need to
% specify the directory to get them from
% savename = sprintf('1000x50_10Jul2017')
