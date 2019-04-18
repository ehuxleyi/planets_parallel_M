% function to execute a single task on a slave processor
%
% This is the code that is executed on multiple processors during parallel
% runs. Each call to the function carries out a task on an individual slave
% processor, where the task has been allocated to it by the master program
%
% where:
%   sim_name   = the name of the simulation (character string)
%   tc         = the number of the task (out of many to implement the whole
%                simulation)
%   tplanets   = a vector list of the numbers of the planets to execute
%   truns      = a vector list of the numbers of the runs to execute
%   pnumnodes  = list of the numbers of nodes of each planet
%   pnodes     = lists of the temperatures of each node of each planet
%   pfeedbacks = lists of the dT/dt's of each node of each planet
%   ptrends    = list of the imposed trend in T for each planet
%   pblamdas   = list of the expected numbers of large perturbations
%   pmlamdas   = list of the expected numbers of medium perturbations
%   pllamdas   = list of the expected numbers of small perturbations
%   tresults_p = results of the runs in this task in terms of planets info
%   tresults_r = results of the runs in this task in terms of run info
%
% and:
%   planets   = array of planet properties to return
%   runs      = array of run properties to return
%--------------------------------------------------------------------------

function [planets, runs] = ts_slave(argss)

% unpack the information from the structure passed to this function
sim_name = argss.arg1;
tc = argss.arg2;
tplanets = argss.arg3;
truns = argss.arg4;
pnumnodes = argss.arg5;
pnodes = argss.arg6;
pfeedbacks = argss.arg7;
ptrends = argss.arg8;
pblambdas = argss.arg9;
pmlambdas = argss.arg10;
pllambdas = argss.arg11;

initialise_slave;

% carry out the specific planets/runs in this task

% for each run in this task
for plc = 1 : length(truns)
    
    %% set up this run
    
    % calculate the overall number of this run out of the whole simulation
    run_number = (tplanets(plc)-1)*nreruns + truns(plc);
    
    % initialise the random number generator for this run
    init_run_rng;
    
    % allocate this planet's set of intrinsic feedbacks from the
    % information supplied to the function
    nnodes = pnumnodes(plc);                     % number of nodes
    Tgap = Trange / (nnodes-1);
    for qq = 1:nnodes_max
        Tnodes(qq) = pnodes(plc,qq);             % T of nodes
        Tfeedbacks(qq) = pfeedbacks(plc,qq);     % dT/dt of nodes
    end
    
    % allocate this planet's long-term forcing from the information
    % supplied to the function
    trend = ptrends(plc);
    
    % allocate this planet's 'neighbourhood' (expected numbers of small,
    % moderate and large perturbations)
    lambda_big    = pblambdas(plc);
    lambda_mid    = pmlambdas(plc);
    lambda_little = pllambdas(plc);
    
    % randomly initialise the planet's surface temperature
    Tinit = determine_initial_T(Tmin, Trange);
    
    % calculate additional and higher-level planet properties that will be
    % used in later analysis
    calc_planet_properties;
    
    % randomly calculate a set of perturbations (instantaneous changes to
    % the planet's surface temperature) for this run
    determine_perturbations;
    
    % ----- Set up ODE options for Matlab engine -----
    options = odeset('Events', @events_pl, 'Refine', 1, ...
        'Reltol', 1e-4, 'Abstol', 0.05, 'MaxStep', 1000, ...
        'InitialStep', 0.01, 'jacobian', @planets_jac);
    
    %% execute the run through its complete history or until the planet
    %  goes sterile, using matlab's ode23s ODE solver
    
    % first stage - up to the first perturbation
    
    % ----- initial conditions -----
    y0 = [ Tinit 0.0 ];             % start temperature
    tstart	= 0;                    % start time
    tfinal	= perturbations(1,1);   % end time
    stcounter = 0;                  % stage counter
    
    % Solve until the temperature exceeds habitable bounds or end of the
    % run is reached
    % planets_ODE = the function defining the ODE
    % [tstart tfinal] = start and end times of the run (if no event)
    % y0 = initial conditions
    % options = options set up above using odeset
    [t,y,te,ye,ie] = ode23s(@planets_ODE,[tstart tfinal], y0, options);
    % t = vector containing the time at each timestep
    % y = vector containing T at each timestep
    % te = time at which an event occurred (Earth went sterile)
    % ye = value of T when this occurred
    % ie = index of event, indicating which occurred
    
    t1 = t;
    y1 = y;
    
    % continue the run from perturbation to perturbation until end is
    % reached or planet has gone sterile
    while (((round(t(end))) < max_duration) && (y(end,1) > Tmin) && ...
            (y(end,1) < Tmax) && (stcounter < pcounter))
        
        % next stage of run
        
        % ----- Sort out mechanics/parameterisation of simulation -----
        stcounter = stcounter + 1;    % increment stage counter
        tstart	= t(end);     % continue from end of last stage
        if (stcounter < pcounter)   % if more perturbations left to do
            tfinal	= perturbations((stcounter+1),1); % until next P
        else     % if all perturbations done
            tfinal	= max_duration; % until end of run
        end
        
        % ----- Set up initial conditions -----
        y(end,1) = y(end,1) + perturbations(stcounter,2);  % add P
        y0 = y(end,:);
        
        % Solve until the temperature exceeds habitable bounds or the end
        % of run is reached
        [t,y,te,ye,ie] = ode23s(@planets_ODE,[tstart tfinal], y0, options);
        
        % accumulate results in arrays
        t = [t1; t];   y = [y1; y];   t1 = t;   y1 = y;
        
    end  % of a rerun (all stageposts from one perturbation to another)
        
    % store information and results, ready to be retrieved after the
    % simulation has finished
    calc_run_properties;   
    planets(plc).pnumber = tplanets(plc);       % number of this planet
    planets(plc).nnodes  = nnodes;              % number of nodes
    for qq = 1:nnodes_max
        planets(plc).Tnodes(qq) = Tnodes(qq);   % T of each node
        planets(plc).Tfeedbacks(qq) = Tfeedbacks(qq);  % dT/dt of each node
    end
    planets(plc).trend = trend;                 % heating or cooling trend
    planets(plc).lambda_big = lambda_big;       % big P freq (av number)
    planets(plc).lambda_mid = lambda_mid;       % mid P freq (av number)
    planets(plc).lambda_little = lambda_little; % little P freq (av number)
    
end  % of all runs/planets for this task
