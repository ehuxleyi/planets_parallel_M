% script to generate a summary of a simulation's results 
% 
% The results that are calculated are those needed to evaluate whether
% results support control by only destiny or only chance. To do so, three
% values of a metric (NHAB, the number of successful planets) are compared:
% 
% 1. NHAB1, the value of NHAB obtained in the simulation.
%
% 2. NHAB2, the value of NHAB expected according to 'destiny' (i.e.
%    according to H2 in the paper). If planets are either (a) pre-destined
%    to be successful, i.e. 100% chance of success from the outset, or (b)
%    pre-destined to fail, i.e. 0% chance of success from the outset, then
%    the fraction of all planets that are habitable should be the same as
%    the fraction of all runs that are habitable. NHAB2 is then equal to
%    the number of successful runs divided by the total number of runs.
%
% 3. NHAB3, the value of NHAB expected according to 'chance' (i.e.
%    according to H1 in the paper). If it is all completely down to chance,
%    i.e. if all runs of all planets have an equal chance of staying
%    habitable, then the probability of each run staying habitable (Pr)
%    should be equal to the number of successful runs divided by the total
%    number of runs (NHAB2, as it happens). The probability of an
%    indvidual planet being habitable at least once out of NR reruns (Pp)
%    is then equal to 1.0 minus the probability of it going sterile all NR
%    times. As an equation:
%    Pp = [1.0 - (1.0-Pr)^NR]
%    NHAB3 is then equal to Pp multiplied by the total number of planets
%    that were simulated.
%
% Although NHAB3 is the most likely value of NHAB if it is all down to
% chance, other values are also possible because  the equivalent of
% 'dice-rolling' is involved. The probability of obtaining any individual
% value of NHAB can be calculated because it follows the binomial
% distribution. The probability of getting exactly k successes out of n
% trials, when each trial has a probability p of success, is therefore
% [n!/(k!*(n-k)!)] * p^k * (1-p)^(n-k)
% This can be calculated in order to see how improbable it is that the
% observed value (NHAB1) could have occurred through chance outcomes 
% -------------------------------------------------------------------------

fprintf('\n  SUMMARY OF RESULTS FROM THIS SIMULATION\n\n');


%% planets
npl = length(planets);
fprintf('Total number of planets was %d\n', npl);
c1 = 0; c2 = 0;
for ii = 1:npl
    if (planets(ii).all_survived)
        c1 = c1 + 1;
    end
    if (planets(ii).any_survived)
        c2 = c2 + 1;
    end
end
fprintf('%d out of %d planets failed every time\n', (npl-c2), npl);
fprintf('%d out of %d planets survived at least once\n', c2, npl);
fprintf('%d out of %d planets survived every time\n\n', c1, npl);


%% runs
nruns = length(runs);
fprintf('Total number of runs was %d\n', nruns);
c3 = 0;
for ii = 1:nruns
    if (runs(ii).result == 1)
        c3 = c3 + 1;
    end
end
fprintf('%d out of %d runs stayed habitable (average of %.1f out of %d reruns per planet)\n', ...
    c3, nruns, (round(10*c3/npl)/10.0), (nruns/npl));
fprintf('%d out of %d runs went uninhabitable (%d too cold, %d too hot)\n\n', ...
    (nruns-c3), nruns, ntoocold, ntoohot);


%% calculate and compare the three values of NHAB

fprintf('NHAB = Number of potentially habitable planets\n');

nhab2 = round(npl*c3/nruns);
fprintf('  NHAB2 (expected acc. to "destiny") = %d\n', nhab2);

nhab1 = c2;
fprintf('  NHAB1 (from simulation) = %d\n', nhab1);

% calculate the overall probability of a run being habitable
Pr = c3 / nruns;
% calculate the probability of one or more out of a planet's multiple
% reruns being habitable, if only a matter of chance
Pp = 1.0 - ((1.0-Pr)^nreruns);
% calculate the most likely number of habitable planets, if all down to
% chance (this is going to be identical to Pp*nplanets in almost all cases)
nhab3 = floor(Pp*(npl+1));
fprintf('  NHAB3 (expected acc. to "chance") = %d\n', nhab3);

% summary statements
if ((nhab2 < nhab1) && (nhab1 < nhab3))
    fprintf('same outcome as standard model (nhab2 < nhab1 < nhab3)\n');
else
    fprintf('\n******* UNEXPECTED RESULT *******\n');
    fprintf('\n\nDIFFERENT OUTCOME FROM STANDARD MODEL: NOT (nhab2 < nhab1 < nhab3)\n');
end

% calculate the probability of nhab = nhab1 if it is all a matter of
% chance. This can be calculated from the binomial distribution for the
% case of npl trials (planets) and Pp chance of success for each planet
pnhab1_chance = binopdf(nhab1,npl,Pp);
fprintf('Probability of (NHAB=%d) if all down to chance is %7.1e\n\n',...
    nhab1, pnhab1_chance);


%% finally, do a runstest and report the result
[h,p,stats] = runstest(allruns_durations);
if (h == 1)
    fprintf('runstest: run durations are NOT randomly distributed (H2 is rejected, p = %7.1e)\n', p);
else
    fprintf('\n******* UNEXPECTED RESULT *******\n');
    fprintf('runstest result: run durations may be randomly distributed (H2 is supported)\n\n');
end
