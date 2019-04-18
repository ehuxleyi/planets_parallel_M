% script to carry out various initialisation tasks before start of a task
% 
% declare variables, set up arrays and structures, etc before a task is run
% on a slave processor
%--------------------------------------------------------------------------

% allow the following to be shared between main program and planets_ode
global Tnodes Tfeedbacks Tgap nnodes trend

% define various constants and parameter values
set_constants;

% initialise arrays
Tnodes = double(zeros([1 nnodes_max]));     % T at each node
Tfeedbacks = double(zeros([1 nnodes_max])); % feedback (dT/dt) at each node
attractors = double(zeros([nnodes_max 14]));  % cannot be more attractors than nodes
attr       = double(zeros([nnodes_max 14]));  % what is this?

% set up structures and arrays to store information about each planet, to
% be used in later analysis 
for pp = 1 : length(tplanets)
    planets(pp).pnumber = NaN;        % number of this planet
    planets(pp).nnodes = NaN;         % number of nodes
    for qq = 1:nnodes_max
        planets(pp).Tnodes(qq) = NaN;         % T of each node
        planets(pp).Tfeedbacks(qq) = NaN;     % dT/dt of each node
    end
    planets(pp).trend = NaN;          % heating or cooling trend
    planets(pp).lambda_big = NaN;     % big P freq (av number)
    planets(pp).lambda_mid = NaN;     % mid P freq (av number)
    planets(pp).lambda_little = NaN;  % little P freq (av number)
    planets(pp).nattractors = NaN;    % number of stable attractors
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
end
    
% set up structures and arrays to store information about each run, to be
% used in later analysis
for rr = 1 : length(truns)
    runs(rr).runnumber = NaN;          % overall number of the run
    runs(rr).planetnumber = NaN;       % number of the planet
    runs(rr).rerunnumber = NaN;        % which rerun it is
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
