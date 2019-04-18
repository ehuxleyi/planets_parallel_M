% script to plot 2 x 1000 circles showing successes on 1st and 2nd reruns
% 
% This is figure 4
% -------------------------------------------------------------------------


%% initialisation

% set constants controlling where the circles are positioned on the plot
xspacing = 12;
yspacing = 12;
xblocksize = xspacing*10 + 20;
yblocksize = yspacing*10 + 20;


%% plot results of first rerun

% set up the figure
fig = figure(80);
fig.Position = [100 100 280 700];

% for each of the thousand planets
for ii = 1:1000
    
    % calculate where to plot this circle
    if (ii <= 500)
        xblock = 1;
        yblock = ceil(ii/100);
    else
        xblock = 2;
        yblock = ceil((ii-500)/100);
    end
    xinblock = xspacing * (1 + mod((ii-1),10));
    yinblock = yspacing * ceil(mod(ii,100)/10);
    if (yinblock == 0)
        yinblock = 120;
    end
    x = ((xblock-1)*xblocksize) + xinblock;
    y = ((yblock-1)*yblocksize) + yinblock;
    
    % calculate the overall run number for the first rerun
    runn1 = (ii-1)*2 + 1;
    
    % plot a different coloured circle depending on whether the run was
    % successful or not
    if (runs(runn1).result == 1)   % if successful, plot green circle
        plot(x, y, 'o', 'MarkerSize', 5, 'MarkerEdgeColor', ...
            [0 1 0], 'MarkerFaceColor', [0 1 0], 'LineWidth', 1.5);
    else                           % if unsuccessful, plot black circle
        plot(x, y, 'o', 'MarkerSize', 5, 'MarkerEdgeColor', ...
            [0 0 0], 'MarkerFaceColor', [0 0 0], 'LineWidth', 0.1);
    end
    hold on;
end
axis([0, 280, 0, 700]);


%% plot results of second rerun

% set up the figure
fig = figure(81);
fig.Position = [500 100 280 700];

% for each of the thousand planets
for ii = 1:1000
    
    % calculate where to plot this circle
    if (ii <= 500)
        xblock = 1;
        yblock = ceil(ii/100);
    else
        xblock = 2;
        yblock = ceil((ii-500)/100);
    end
    xinblock = xspacing * (1 + mod((ii-1),10));
    yinblock = yspacing * ceil(mod(ii,100)/10);
    if (yinblock == 0)
        yinblock = 120;
    end
    x = ((xblock-1)*xblocksize) + xinblock;
    y = ((yblock-1)*yblocksize) + yinblock;
    
    xx(ii) = x;
    yy(ii) = y;
    
    % calculate the overall run number for the second rerun
    runn2 = (ii-1)*2 + 2;
    
    % plot a different symbol depending on whether the run was successful
    % or not
    if (runs(runn2).result == 1)   % if successful, plot green circle
        plot(x, y, 'o', 'MarkerSize', 5, 'MarkerEdgeColor', ...
            [0 1 0], 'MarkerFaceColor', [0 1 0], 'LineWidth', 1.5);
    else                           % if unsuccessful, plot black circle
        plot(x, y, 'o', 'MarkerSize', 5, 'MarkerEdgeColor', ...
            [0 0 0], 'MarkerFaceColor', [0 0 0], 'LineWidth', 0.1);
    end
    hold on;
end
axis([0, 280, 0, 700]);
