% function to detect when the integration should be interrupted
% 
% Calculates if planetary temperature has exited the habitable range (if
% the planet has gone sterile)
%--------------------------------------------------------------------------

function [value, isterminal, direction] = events_pl(t, y)

global Tmin Tmax

% artificial function which is zero at habitability limits and nowhere else
if ((y(1) < Tmin) || (y(1) > Tmax))
    c1 = 0.0;
else
    c1 = 1.0;
end
value      = c1;
isterminal = 1;    % These are terminal, stop integration
direction  = 0;    % regardless of direction solution is moving in
