% script to calculate some properties of a planet
% 
% These properties can be compared later to success rates how often the
% planet survives so as to give a clue as to which factors are most
% important in determining survival likelihood.
%--------------------------------------------------------------------------

% calculate the properties of any stable attractors for this planet.
% do this only for the initial state, before affected by the trend
feedbacks = Tfeedbacks;
calc_attractor_properties;

% calculate the asymmetry of the feedbacks (left +ve & right -ve will tend
% to favour stability whereas left -ve & right +ve is inimical to it)
% again, do this only for the initial state, before affected by the trend
calc_asymmetry;

% likewise for runaway feedback zones
calc_runaways;
% copy dummy values for plotting to real values for analysis
icehT = runaway_freeze;
greenhT = runaway_boil;

% now loop over all of the stable attractors for this planet to calculate
% properties for the set of feedbacks as a whole, such as the power and
% position of the most powerful stable attractor
if (nattractors ~= 0)   % at least one stable attractor exists
    maxwidth = 0;
    maxheight = 0;
    maxstrength = 0;
    maxpower = 0;
    nmostpowerful = NaN;
    for mm = 1:nattractors
        if (attractors(mm,11) > maxwidth)
            maxwidth = attractors(mm,11);
        end
        if (attractors(mm,8) > maxheight)
            maxheight = attractors(mm,8);
        end
        if (attractors(mm,12) > maxstrength)
            maxstrength = attractors(mm,12);
        end
        if (attractors(mm,13) > maxpower)
            maxpower = attractors(mm,13);
            nmostpowerful = mm;
        end
    end
    pos1mostpowerful = attractors(nmostpowerful,1);
    dist1mostpowerful = attractors(nmostpowerful,14);
    % an alternative definition of the 'position' of a stable attractor is
    % its midpoint (half-way between its LH and RH edges) rather than its
    % zero crossing point
    pos2mostpowerful = 0.5 * ...
        (attractors(nmostpowerful,9)+attractors(nmostpowerful,10));
    dist2mostpowerful = abs(pos2mostpowerful-(0.5*(Tmax+Tmin)));
else    % no stable attractors for this planet so set all to NaNs
    maxwidth = NaN;
    maxheight = NaN;
    maxstrength = NaN;
    maxpower = NaN;
    pos1mostpowerful = NaN;
    dist1mostpowerful = NaN;
    pos2mostpowerful = NaN;
    dist2mostpowerful = NaN;
end

% now calculate the absolute magnitude of the temporal trend
trend_size = abs(trend);

% calculate the percentage of the habitable temperature range that
% is susceptible to a runaway icehouse or a runaway greenhouse positive
% feedback (needed for statistics)
pc_runaway = 100.0 * ((icehT-Tmin) + (Tmax-greenhT)) / (Tmax-Tmin);

% save planet information for later analysis
planets(plc).nattractors = nattractors;   % number of stable attractors
planets(plc).lambda_big = lambda_big;   % perturbation expected Ns
planets(plc).lambda_mid = lambda_mid;
planets(plc).lambda_little = lambda_little;
planets(plc).max_attr_width = maxwidth;
planets(plc).max_attr_height = maxheight;
planets(plc).max_attr_strength = maxstrength;
planets(plc).max_attr_power = maxpower;
planets(plc).max_attr_pos1 = pos1mostpowerful;
planets(plc).max_attr_dist1 = dist1mostpowerful;
planets(plc).max_attr_pos2 = pos2mostpowerful;
planets(plc).max_attr_dist2 = dist2mostpowerful;
planets(plc).pcrunaway = pc_runaway;
planets(plc).asymmetry = asymm;
