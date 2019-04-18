% script to package the input information for a task into one structure
%--------------------------------------------------------------------------

% initialise arrays in which to pass task information to slave
task_nnodes    = double(zeros([nr 1])); % numbers of nodes of each planet
task_nodes     = double(zeros([nr nnodes_max])); % T at each node
task_feedbacks = double(zeros([nr nnodes_max])); % feedback dT/dt at nodes
task_trends    = double(zeros([nr 1])); % trend for each planet
task_blambdas  = double(zeros([nr 1])); % big P freqs for each planet
task_mlambdas  = double(zeros([nr 1])); % mid P freqs for each planet
task_llambdas  = double(zeros([nr 1])); % little P freqs for each planet

% populate arrays with task information to pass to slave
for kk = 1 : nr   % for each run in this task
    pp = task_planets(tt,kk);  % calculate the planet number
    task_nnodes(kk) = planets(pp).nnodes;
    for qq = 1:task_nnodes(kk)
        task_nodes(kk,qq)     = planets(pp).Tnodes(qq);
        task_feedbacks(kk,qq) = planets(pp).Tfeedbacks(qq);
    end
    % fill unused nodes with NaNs (e.g. if only 5 nodes but array has
    % space for 20)
    for qq = (task_nnodes(kk)+1):nnodes_max
        task_nodes(kk,qq)     = NaN;
        task_feedbacks(kk,qq) = NaN;
    end
    task_trends(kk) = planets(pp).trend;
    task_blambdas(kk) =  planets(pp).lambda_big;
    task_mlambdas(kk) =  planets(pp).lambda_mid;
    task_llambdas(kk) =  planets(pp).lambda_little;
end

% put the arrays with the task information into a single structure
s = struct('arg1', savename, ...   % string
    'arg2', tt, ...                    % integer
    'arg3', [task_planets(tt,1:nr)], ...    % vector of integers
    'arg4', [task_runs(tt,1:nr)], ...       % vector of integers
    'arg5', task_nnodes, ...       % vector of integers
    'arg6', task_nodes, ...        % array of doubles
    'arg7', task_feedbacks, ...    % array of doubles
    'arg8', task_trends, ...       % vector of doubles
    'arg9', task_blambdas, ...     % vector of doubles
    'arg10', task_mlambdas, ...    % vector of doubles
    'arg11', task_llambdas);        % vector of doubles
