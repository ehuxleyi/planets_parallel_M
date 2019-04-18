% script to plot success rates on both stem and standard plots
% -------------------------------------------------------------------------


%% initialisation

% calculate how many 100% successful planets it would take to produce the
% same number of successful runs overall
equivnum_perfectplanets = round(sum(allplanets_srates));

% calculate the expected distribution of planetary successes if down to
% pure chance (use a Monte-Carlo method)
pure_chance_rates;

% specify a colour to be used in the plots
stem_colour = [(43/255) (94/255) (172/255)];


%% produce stem plots of success rates

f = figure(74);
set (f, 'Position', [100 200 800 600]);


% stem plot of all of the sucessful planets (ones which stayed habitable
% throughout the duration of at least one of their reruns), with the height
% of each stem being their success rate expressed as a percentage
subplot(3,1,1);
hold on;
A = sort(allplanets_srates);   % sort the list in ascending order
A = 100.0 * A;                 % convert from fractions to percentages
x = 1:length(A);
p1 = stem(x, A, 'LineWidth', 0.7, 'Color', stem_colour);
xlim([0 length(A)]);  ylim([0 100]);
xlabel('all planets in success order'); ylabel('% of successful runs');
% add red shaded area to show expected distribution for pure destiny
equivindex = x(length(A)+1-equivnum_perfectplanets);
if (equivindex < 1)
    xequiv = -100;
else
    xequiv = x(equivindex);
end
fill([xequiv xequiv x(end)+1 x(end)+1], [0 100 100 0], [1.0 0.7 0.7], ...
    'Linewidth', 0.1);
plot ([1 xequiv xequiv x(end)], [0 0 100 100], '-r', 'Linewidth', 1.0);
% add black line and grey fill to show expected distribution for pure chance
hold on;
x2 = [-1 x x(end)+1 x(end)+1 -1];
y2 = [chance50(1) chance50 chance50(end) 0 0];
fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1);
plot (x, chance50, '-k', 'Linewidth', 1.0);
hold on;
% replot LH y-axis
plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
hold on;
% copy stem plot back over the top
copyobj(p1,gca);
hold on;

% add a customised legend
h = zeros(3, 1);
h(1) = plot(NaN,NaN,'-k');
h(2) = plot(NaN,NaN,'-r');
h(3) = plot(NaN,NaN,'-ob', 'Color', stem_colour);
legend(h, 'H1, chance alone', 'H2, mechanism alone', ...
    'simulation results' ,'Location', 'northwest');


% stem plot of all of the sucessful planets (ones which stayed habitable
% throughout the duration of at least one of their reruns), with the height
% of each stem being the success rate expressed as a percentage
subplot(3,1,2);
hold on;
B = A(A~=0);  % non-zero elements of A, i.e. planets that succeeded at least once
x = 1:length(B);
p1 = stem(x, B, 'LineWidth', 1.0, 'Color', stem_colour);
xlim([0 length(B)]);  ylim([0 100]);
xlabel('all successful planets in success order'); ylabel('% of successful runs');
% add red shaded area to show expected distribution for pure destiny
equivindex = x(length(B)+1-equivnum_perfectplanets);
if (equivindex < 1)
    xequiv = -100;
else
    xequiv = x(equivindex);
end
fill([xequiv xequiv x(end)+1 x(end)+1], [0 100 100 0], [1.0 0.7 0.7], ...
    'LineWidth', 0.1);
plot ([1 xequiv xequiv x(end)], [0 0 100 100], '-r', 'Linewidth', 1.0);
% add black line and grey fill to show expected distribution for pure chance
hold on;
x2 = [-1 x x(end)+1 x(end)+1 -1];
y3 = chance50((1+length(chance50)-length(x)):length(chance50));
y2 = [y3(1) y3 y3(end) 0 0];
fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1);
plot (x, chance50((1+length(chance50)-length(x)):length(chance50)), ...
    '-k', 'Linewidth', 1.0);
hold on;
% replot LH y-axis
plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
hold on;
% copy stem plot back over the top
copyobj(p1,gca);


% stem plot of the top 100 most sucessful planets, with the height of each
% stem being the success rate expressed as a percentage
subplot(3,1,3);
hold on;
startindex = length(A) - 99;  % -99 not -100 else get top 101 planets
if (startindex < 1)
    startindex = 1;
end
C = A(startindex:end);        % top 100 only, rather than all of them
x = 1:length(C);
p1 = stem(x, C, 'LineWidth', 1.0, 'Color', stem_colour);
xlim([0 length(C)]);  ylim([0 100]);
xlabel('top 100 planets in success order'); ylabel('% of successful runs');
% add red shaded area to show expected distribution for pure destiny
if (equivnum_perfectplanets < 100)
    equivindex = x(length(C)+1-equivnum_perfectplanets);
    if (equivindex < 1)
        xequiv = -100;
    else
        xequiv = x(equivindex);
    end
else
    % the shaded area for the equivalent number of totally successful
    % planets will stretch right across if there are 100 or more of them
    xequiv = 0;
end
fill([xequiv xequiv x(end)+1 x(end)+1], [0 100 100 0], [1.0 0.7 0.7], ...
    'LineWidth', 0.1);
plot ([1 xequiv xequiv x(end)], [0 0 100 100], '-r', 'Linewidth', 1.0);
% add black line and grey fill to show expected distribution for pure chance
hold on;
%x2 = x; x2(end+1) = x(end); x2(end+2) = 1;
x2 = [-1 x x(end)+1 x(end)+1 -1];
y3 = chance50(startindex:end);
y2 = [y3(1) y3 y3(end) 0 0];
fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1);
plot (x, chance50(startindex:end), '-k', 'Linewidth', 1.0);
hold on;
% replot LH y-axis
plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
hold on;
% copy stem plot back over the top
copyobj(p1,gca);

% title for this figure (not for the subplot)
[a,h] = suplabel('Stem Plots of Success Rates of Successful Planets');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


%% produce line plots of success rates

f = figure(75);
set (f, 'Position', [200 200 900 600]);


% line plot of all of the sucessful planets (ones which stayed habitable
% throughout the duration of at least one of their reruns), with the height
% of each point being the success rate expressed as a percentage
subplot(3,1,1);
hold on;
A = sort(allplanets_srates);   % sort the list in ascending order
A = 100.0 * A;                 % convert from fractions to percentages
x1 = 1:length(A);
p1 = plot(x1', A, '-k', 'LineWidth', 1.5, 'Color', stem_colour);
xlim([0 length(A)]);  ylim([0 100]);
xlabel('all planets in success order'); ylabel('% of successful runs');
% add red shaded area to show expected distribution for pure destiny
equivindex = length(A) + 1 - equivnum_perfectplanets;
fill([x1(equivindex) x1(equivindex) x1(end)+1 x1(end)+1], ...
    [0 100 100 0], [1.0 0.7 0.7], 'LineWidth', 0.1);
p2 = plot([1 x1(equivindex) x1(equivindex) x1(end)], [0 0 100 100], ...
    '-r', 'LineWidth', 1.0);
% add black line and grey fill to show expected distribution for pure
% chance
hold on;
x2 = [-1 x1 x1(end)+1 x1(end)+1 -1];
y2 = [chance50(1) chance50 chance50(end) 0 0];
fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1, ...
    'FaceAlpha', 0.75, 'EdgeAlpha', 0.75);
plot (x1, chance50, '-k', 'Linewidth', 1.0);
hold on;
% replot LH and RH y-axes
plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
hold on;
plot ([x1(end) x1(end)], [0 100], '-k', 'LineWidth', 0.5);
hold on;
% copy plot back over the top
copyobj(p1,gca);
hold on;

% add a customised legend
h = zeros(3, 1);
h(1) = plot(NaN,NaN,'-k');
h(2) = plot(NaN,NaN,'-r');
h(3) = plot(NaN,NaN,'-b', 'Color', stem_colour);
legend(h, 'H1, chance alone', 'H2, properties alone', ...
    'simulation results' ,'Location', 'northwest');


% line plot of all of the sucessful planets (ones which stayed habitable
% throughout the duration of at least one of their reruns), with the height
% of each point being the success rate expressed as a percentage
subplot(3,1,2);
hold on;
B = A(A~=0); % non-zero elements of A (i.e. planets with some success)
x1 = 1:length(B);
x3 = [0 x1];
p1 = plot(x3', [0; B], '-k', 'LineWidth', 1.5, 'Color', stem_colour);
xlim([0 length(B)]);  ylim([0 100]);
xlabel('all successful planets in success order'); 
ylabel('% of successful runs');
% add red shaded area to show expected distribution for pure destiny
equivindex = length(B) + 1 - equivnum_perfectplanets;
fill([x1(equivindex) x1(equivindex) x1(end)+1 x1(end)+1], ...
    [0 100 100 0], [1.0 0.7 0.7], 'Linewidth',0.7);
p2 = plot([1 x1(equivindex) x1(equivindex) x1(end)], ...
    [0 0 100 100], '-r', 'LineWidth', 1.0);
% add black line and grey fill to show expected distribution for pure
% chance
hold on;
x2 = [-1 x1 x1(end)+1 x1(end)+1 -1];
y3 = chance50((1+length(chance50)-length(x1)):length(chance50));
y2 = [y3(1) y3 y3(end) 0 0];
fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1);
plot (x1, chance50((1+length(chance50)-length(x1)):length(chance50)), ...
    '-b', 'Linewidth', 1.0);
hold on;
% replot LH and Rh y-axes
plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
hold on;
plot ([x1(end) x1(end)], [0 100], '-k', 'LineWidth', 0.5);
hold on;
% copy plot back over the top
copyobj(p1,gca);


% line plot of the top 100 most sucessful planets, with the height of each
% point being the success rate expressed as a percentage
subplot(3,1,3);
hold on;
startindex = length(A) - 99;  % -99 not -100 else get top 101 planets
if (startindex < 1)
    startindex = 1;
end
C = A(startindex:end);        % top 100 only, rather than all of them
x1 = 1:length(C);
if (startindex == 1)
    preceding = A(1);
else
    preceding = A(startindex-1);
end
p1 = plot([0 x1]', [preceding; C], '-k', 'LineWidth', 1.5, ...
    'Color', stem_colour);
xlim([0 length(C)]);  ylim([0 100]);
xlabel('top 100 planets in success order'); ylabel('% of successful runs');
% add red shaded area to show expected distribution for pure destiny
if (equivnum_perfectplanets < 100)
    equivindex = length(C) + 1 - equivnum_perfectplanets;
    fill([x1(equivindex) x1(equivindex) x1(end)+1 x1(end)+1], ...
        [0 100 100 0], [1.0 0.7 0.7], 'LineWidth', 0.1);
    p2 = plot([1 x1(equivindex) x1(equivindex) x1(end)], [0 0 100 100], ...
        '-r', 'LineWidth', 1.0);
    % add black line and grey fill to show expected distribution for pure
    % chance
    hold on;
    x2 = [-1 x1 x1(end)+1 x1(end)+1 -1];
    y3 = chance50((1+length(chance50)-length(x1)):length(chance50));
    y2 = [y3(1) y3 y3(end) 0 0];
    fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1);
    plot (x1, y3, '-k', 'Linewidth', 1.0);
    hold on;
    % replot LH and Rh y-axes
    plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
    hold on;
    plot ([x1(end) x1(end)], [0 100], '-k', 'LineWidth', 0.5);
    hold on;
    % copy plot back over the top
    copyobj(p1,gca);
else
    % the shaded area for the equivalent number of totally successful
    % planets will stretch right across if there are 100 or more of them
    fill([0 0 x1(end)+1 x1(end)+1], [0 100 100 0], ...
        [1.0 0.7 0.7], 'LineWidth', 0.1);
    equivindex = length(C) + 1 - equivnum_perfectplanets;
    p2 = plot([1 0 0 x1(end)], [0 0 100 100], '-r', ...
        'LineWidth', 1.0);
    % add black line and grey fill to show expected distribution for pure
    % chance 
    hold on;
    x2 = [-1 x1 x1(end)+1 x1(end)+1 -1];
    y3 = chance50(startindex:end);
    y2 = [y3(1) y3 y3(end) 0 0];
    fill(x2, y2, [0.8 0.8 0.8], 'LineWidth', 0.1);
    plot (x1, chance50(startindex:end), '-k', 'Linewidth', 1.0);
    hold on;
    % replot LH and RH y-axes
    plot ([0 0], [0 100], '-k', 'LineWidth', 0.5);
    hold on;
    plot ([x1(end) x1(end)], [0 100], '-k', 'LineWidth', 0.5);
    hold on;
    % copy plot back over the top
    copyobj(p1,gca);
end

% title for this figure (not for the subplot)
[a,h] = suplabel('Standard Plots of Success Rates of Successful Planets');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');
