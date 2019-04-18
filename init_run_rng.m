% script to initialise the random number generator prior to a run
%--------------------------------------------------------------------------

if (rndmode == 1) % 'truly random'
    dv = datevec(now);  % get current time
    secs = dv(6);  % extract seconds and milliseconds
    % generate a number that is a combination of both the current time and
    % the overall number of this run. This number will therefore be
    % different for the same runnumber when executed at different times,
    % and also for different runs when executed at the same time. 
    rseed = 1000*secs + run_number;
    rng(rseed);   % seed the random number generator
else % 'deterministically random' (same set of random numbers every time)
    rng(run_number);
    error('rndmode should be 1');
end
