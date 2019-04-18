% script to calculate the asymmetry of the feedbacks
% 
% A symmetrical system of feedbacks will have equal amounts of +ve
% (warming) and -ve (cooling) feedbacks either side of the mid-point
% temperature. In theory, the best possible system of feedbacks is likely
% to be one where the feedbacks are strongly cooling at all temperatures
% above the mid-point and strongly warming at all temperatures below the
% mid-point, i.e. highly asymmetrical. This metric calculates the degree of
% asymmetry, going from the likely worst scenario (dT/dt = -delTmax at all
% low Ts, = +delTmax at all high Ts) to the likely best scenario (dT/dt =
% +delTmax at all low Ts, = -delTmax at all high Ts)
% -------------------------------------------------------------------------

TTnumber = 200; 
Tmid = (Tmin+Tmax)/2.0;
TTgap = (Trange/TTnumber);
asymm = 0;

for TT = Tmin : TTgap : Tmax
    
    % calculate dT/dt at this T:
    
    % work out which nodes this particular value of T is between.
    node_bef = 1 + floor((TT-Tmin)/Tgap);
    node_aft = 1 + ceil((TT-Tmin)/Tgap);
    
    % if T is exactly at a node, then use the feedback value for that node
    if (node_bef == node_aft)
        delTT = Tfeedbacks(node_aft);
        
    % else if T is between nodes then calculate dT/dt by interpolation
    else
        
        % calculate weightings for dT/dt at nodes before and after T
        weight_bef = (Tnodes(node_aft)-TT) / Tgap;
        weight_aft = (TT-Tnodes(node_bef)) / Tgap;
        
        % linear interpolation between dT/dt values at the two nodes (and
        % for this purpose calculate only at the beginning, ignoring any
        % contribution of the trend in dT/dt)
        delTT = (Tfeedbacks(node_bef)*weight_bef) + ...
            (Tfeedbacks(node_aft)*weight_aft);
    end
    
    % add the +ve or -ve contribution to the asymmetry
    if (TT < Tmid)
        asymm = asymm + (TTgap*delTT);
    elseif (TT > Tmid)
        asymm = asymm - (TTgap*delTT);  % i.e. -ve dT/dt adds to asymm
    end
end
