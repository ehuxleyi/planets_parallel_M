% script to initialise the random number generator prior to a simulation
%--------------------------------------------------------------------------

if (rndmode == 1) % 'truly random'
    % seed the random number generator based on the current time and
    % specify to use the Mersenne Twister random number generator
    rng('shuffle', 'twister');
else % 'deterministically random' (same set of random numbers every time)
    rng(nplanets);
    error('rndmode should be 1');
end
