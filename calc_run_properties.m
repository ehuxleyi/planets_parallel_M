% script to calculate some properties of a run
% 
% These properties can be compared later to success rates how often the
% planet survives so as to give a clue as to which factors are most
% important in determining survival likelihood.
%--------------------------------------------------------------------------

% work out how long the run lasted for
run_duration = t(end);

% run was successful if remained habitable throughout the whole duration
if (abs((max_duration-run_duration)/max_duration) < 0.001)
    run_result = 1;
    % if it failed, give a different answer depending in whether failed
    % because got too hot (0) or too cold (-1)
elseif (y(end,1) >= Tmax)
    run_result = 0;
else
    run_result = -1;
end
    
% calculate the magnitude of the largest perturbation during the duration
% of the run (however long it actually lasted)
mm = 1;    % counter for perturbations
biggest_actual_perturbation = 0.0;
biggest_perturbation_time = NaN;
% for each perturbation in the list that occurred before the end of the run
while ((mm <= pcounter) && (perturbations(mm,1) <= run_duration))
    if (abs(perturbations(mm,2)) > abs(biggest_actual_perturbation))
        biggest_actual_perturbation = perturbations(mm,2);
        biggest_perturbation_time = perturbations(mm,1);
    end
    mm = mm + 1;
end

% calculate the standard deviation of the temperatures during the run
Tstddev = std(y(:,1));

% calculate the mode temperature, i.e. the most frequently occurring value.
% Since T is a real number, calculate the most frequently occurring integer
% temperature.
% NB: using floor not round so if upper limit to habitability is 60C then
% highest possible mode value is 59C.
% NB2: if there are multiple most frequent values then 'mode' returns only
% the lowest one, so there is a second (small?) inbuilt bias towards the
% lower end of the range.
Tmost_frequent = mode(floor(y(:,1)));

% fit a straight line to the temperature time-series and calculate the
% slope (i.e. the long-term trend). In this case 'trend' refers to the
% observed trend in T rather than the imposed trend in dT/dt. To avoid
% problems with infinitely steep slopes, they are calculated as angles
% (i.e. between -pi/2 and +pi/2)
coeffs = polyfit(t, y(:,1), 1);
trendslope = coeffs(1) * 1e6;         % slope
Ttrend_observed = atan(trendslope/100) * 180.0 / pi; % as angle in degrees

% calculate the fraction of time spent in each stable attractor, in
% the most powerful stable attractor, and the fraction of time spent
% elsewhere (not in any stable attractor)
num_tpoints = length(t);
tpoint_counters = zeros([1 nattractors]);   % initialise counters
elsewhere_counter = 0;
for ttt = 1:num_tpoints
    % calculate the length of time nearest this timepoint (equals half the
    % distance either way to adjacent timepoints)
    if (ttt == 1)
        timehere = 0.5*t(ttt+1);
    elseif (ttt == num_tpoints)
        timehere = 0.5*(run_duration-t(ttt-1));
    else
        timehere = 0.5*(t(ttt+1)-t(ttt-1));
    end
    within_sa = 0;
    for kk = 1:nattractors    % for each stable attractor
        if ((y(ttt,1) >= attractors(kk,9)) && ...
            (y(ttt,1) <= attractors(kk,10))) % if within attr basin limits
            tpoint_counters(kk) = tpoint_counters(kk) + timehere;
            within_sa = 1;
        end
    end
    if (within_sa == 0)
        elsewhere_counter = elsewhere_counter + timehere;
    end
end
% convert to fractions of total time (by dividing by the run duration)
for kk = 1:nattractors            
    tpoint_counters(kk) = tpoint_counters(kk) / run_duration;
end
elsewhere_counter = elsewhere_counter / run_duration;

% calculate the position of the stable attractor the system spent the most
% time in
nmostoccupied = 0;
greatest_time = 0;
for kk = 1:nattractors            
    if (tpoint_counters(kk) > greatest_time)
        nmostoccupied = kk;
        greatest_time = tpoint_counters(kk);
    end
end
if (~isnan(nmostoccupied) && (nmostoccupied > 0))
    pos_dominant_sa = attractors(nmostoccupied,1);
else
    pos_dominant_sa = NaN;
end

% save run information for later analysis
runs(plc).runnumber = run_number;      % overall number of the run
runs(plc).planetnumber = tplanets(plc);% number of the planet
runs(plc).rerunnumber = truns(plc);    % which rerun it is
runs(plc).result = run_result;         % outcome of run (whether it stayed habitable for 3 By or not)
runs(plc).length = run_duration;       % how long it lasted for in units of By 
runs(plc).max_potential_perturbation = max_perturbation;   % magnitude of largest 'kick' if continued for 3 By
runs(plc).max_actual_perturbation = biggest_actual_perturbation;   % magnitude of largest actual 'kick'
runs(plc).Tinit = Tinit;               % starting temperature
runs(plc).standard_deviation = Tstddev;% standard deviation of T during run
runs(plc).Ttrend = Ttrend_observed;    % observed trend over time of T during run
runs(plc).Tmode = Tmost_frequent;      % mode (most frequent) T during run
% if there is at least one stable attractor
if (nattractors > 0)
    runs(plc).frtime_in_sas = 1.0 - elsewhere_counter;   % fraction of time during run spent within stable attractor limits
    runs(plc).frtime_elsewhere = elsewhere_counter;      % fraction of time during run spent outside stable attractor limits
    runs(plc).frtime_mostpowerful_sa = tpoint_counters(nmostpowerful);   % fraction of time during run spent within the limits of the most powerful stable attractor limits
    % if at least some time was spent in a stable attractor (might have
    % spent the whole time in a runaway feedback zone)
    if (nmostoccupied > 0)
        runs(plc).frtime_mostoccupied_sa = ...
            tpoint_counters(nmostoccupied);   % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
    else
        runs(plc).frtime_mostoccupied_sa = 0.0;
    end
    runs(plc).pos_mostocuupied_sa = pos_dominant_sa;      % position of the most occupied stable attractor
else
    runs(plc).frtime_in_sas = 0.0;
    runs(plc).frtime_elsewhere = 1.0;
    runs(plc).frtime_mostpowerful_sa = NaN;
    runs(plc).frtime_mostoccupied_sa = NaN;
    runs(plc).pos_mostocuupied_sa = NaN;
end
