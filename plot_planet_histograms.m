% script to produce 12 figures showing frequency distributions for planets
% 
% Histograms show the frequency distributions among planets of various
% properties (for instance, how often planets have 0, 1, 2 etc stable
% attractors). Line plots of frequency distributions are also produced.
% 
% The following types of plot are produced (for each property):
% 1. histogram of frequency distribution for all planets
% 2. histogram of frequency distribution for successful planets only
% 3. line plot comparing the two distributions
% 4. line plot showing the ratio of the two (the tau-statistic)
% -------------------------------------------------------------------------


%% initialisation
% make the axes labels be small (font size 9) for the histograms
set(0, 'DefaultAxesFontSize', 9);


%% 1. histograms of frequency distribution for all planets, and
%  2. histograms of frequency distribution for successful planets only

% first multi-panel figure for planet histograms (part 1, all planets)
f = figure(22); clf('reset');
set (f, 'Position', [200 200 400 800]);

% histogram versus number of nodes
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 1:nnodes_max;
bar(x,fr_nodes(:,1));  % use frequencies calculated earlier
xlim([1 nnodes_max+1]);
xlabel('# nodes'); ylabel('freq');

% histogram versus number of stable attractors
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 0:nnodes_max;   % can have 0 stable attractors
bar(x,fr_attrs(:,1));
xlim([-1 (nnodes_max/2+1)]);
xlabel('# stable attractors'); ylabel('freq');

% histogram versus greatest stable attractor width
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(2*nbinsd)) : (Trange/nbinsd) : ...
    (((2*nbinsd)-1)*Trange/(2*nbinsd));
bar(x,fr_widths(:,1));
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('freq');

% histogram versus greatest stable attractor strength
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (frange/(4*nbinsd)) : (frange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*frange/(4*nbinsd));
bar(x,fr_strengths(:,1));
xlim([0 (frange/2.0)]);
xlabel('max. SA strength'); ylabel('freq');

% histogram versus greatest stable attractor power
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
powmax = Trange*(frange/2.0);
x = (powmax/(2*nbinsd)) : (powmax/nbinsd) : (powmax-(powmax/(2*nbinsd)));
bar(x,fr_powers(:,1));
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('freq');

% histogram versus asymmetry (a planet is more likely to be successful if
% dT/dt is generally +ve at low T, -ve at high T)
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
asymm_max = Trange*frange/2.0;
thisgap = 2.0 * asymm_max / nbinsd;
x = (-asymm_max+(thisgap/2.0)) : thisgap : (asymm_max-(thisgap/2.0));
bar(x,fr_asymms(:,1));
xlim([-asymm_max asymm_max]);
xlabel('asymmetry in feedbacks'); ylabel('freq');

% title for this fgure (not for the subplot)
[a,h] = suplabel('Planet Histograms 1 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet histograms (part 1, hab planets)
f = figure(23); clf('reset');
set (f, 'Position', [275 200 400 800]);

% histogram versus number of nodes
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 1:nnodes_max;
bar(x,fr_nodes(:,2));
xlim([1 nnodes_max+1]);
xlabel('# nodes'); ylabel('freq');

% histogram versus number of stable attractors
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 0:nnodes_max;   % can have 0 stable attractors
bar(x,fr_attrs(:,2));
xlim([-1 (nnodes_max/2+1)]);
xlabel('# stable attractors'); ylabel('freq');

% histogram versus greatest stable attractor width
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(2*nbinsd)) : (Trange/nbinsd) : ...
    (((2*nbinsd)-1)*Trange/(2*nbinsd));
bar(x,fr_widths(:,2));
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('freq');

% histogram versus greatest stable attractor strength
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (frange/(4*nbinsd)) : (frange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*frange/(4*nbinsd));
bar(x,fr_strengths(:,2));
xlim([0 (frange/2.0)]);
xlabel('max. SA strength'); ylabel('freq');

% histogram versus greatest stable attractor power
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
powmax = Trange*(frange/2.0);
x = (powmax/(2*nbinsd)) : (powmax/nbinsd) : (powmax-(powmax/(2*nbinsd)));
bar(x,fr_powers(:,2));
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('freq');

% histogram versus asymmetry (a planet is more likely to be successful if
% dT/dt is generally +ve at low T, -ve at high T)
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
asymm_max = Trange*frange/2.0;
thisgap = 2.0 * asymm_max / nbinsd;
x = (-asymm_max+(thisgap/2.0)) : thisgap : (asymm_max-(thisgap/2.0));
bar(x,fr_asymms(:,2));
xlim([-asymm_max asymm_max]);
xlabel('asymmetry in feedbacks'); ylabel('freq');

% title for this figure (not for the subplot)
[a,h] = suplabel('Planet Histograms 1 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for planet histograms (part 2, all planets)
f = figure(24); clf('reset');
set (f, 'Position', [350 200 400 800]);

% histogram versus trends
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
trendr = trendmax-trendmin;
x = (trendmin+(trendr/(2*nbinsd))) : (trendr/nbinsd) : ...
    (trendmax-(trendr/(2*nbinsd)));
bar(x,fr_trends(:,1));
xlim([trendmin trendmax]);
xlabel('imposed trend in dT/dt'); ylabel('freq');

% histogram versus potency of runaway feedbacks
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (0.0+(1.0/(2*nbinsd))) : (1.0/nbinsd) : ...
    (1.0-(1.0/(2*nbinsd)));
bar(x,fr_runaways(:,1));
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('freq');

% histogram versus positions of main stable attractor (first definition)
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos1s(:,1));
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('freq');

% histogram versus distances of main stable attractor from midpoint (first
% definition)
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist1s(:,1));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('freq');

% histogram versus positions of main stable attractor (second definition)
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos2s(:,1));
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('freq');

% histogram versus distances of main stable attractor from midpoint (second
% definition)
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist2s(:,1));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('freq');

[a,h] = suplabel('Planet Histograms 2 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fourth multi-panel figure for planet histograms (part 2, hab planets)
f = figure(25); clf('reset');
set (f, 'Position', [425 200 400 800]);

% histogram versus trends
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
trendr = trendmax-trendmin;
x = (trendmin+(trendr/(2*nbinsd))) : (trendr/nbinsd) : ...
    (trendmax-(trendr/(2*nbinsd)));
bar(x,fr_trends(:,2));
xlim([trendmin trendmax]);
xlabel('imposed trend in dT/dt'); ylabel('freq');

% histogram versus potency of runaway feedbacks
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (0.0+(1.0/(2*nbinsd))) : (1.0/nbinsd) : ...
    (1.0-(1.0/(2*nbinsd)));
bar(x,fr_runaways(:,2));
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('freq');

% histogram versus positions of main stable attractor (first definition)
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos1s(:,2));
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('freq');

% histogram versus distances of main stable attractor from midpoint (first
% definition)
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist1s(:,2));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('freq');

% histogram versus positions of main stable attractor (second definition)
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos2s(:,2));
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('freq');

% histogram versus distances of main stable attractor from midpoint (second
% definition)
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist2s(:,2));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('freq');

[a,h] = suplabel('Planet Histograms 2 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fifth multi-panel figure for planet histograms (part 3, all planets)
f = figure(26); clf('reset');
set (f, 'Position', [500 200 400 800]);

% histogram versus expected number of small perturbations
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_littlep/(2*nbinsd)) : (maxavnumber_littlep/nbinsd) : ...
    (maxavnumber_littlep-(maxavnumber_littlep/(2*nbinsd)));
bar(x,fr_llambdas(:,1));
xlim([0 maxavnumber_littlep]);
xlabel('{\lambda} for smaller perturbations'); ylabel('freq');

% histogram versus expected number of medium perturbations
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_midp/(2*nbinsd)) : (maxavnumber_midp/nbinsd) : ...
    (maxavnumber_midp-(maxavnumber_midp/(2*nbinsd)));
bar(x,fr_mlambdas(:,1));
xlim([0 maxavnumber_midp]);
xlabel('{\lambda} for mid-sized perturbations'); ylabel('freq');

% histogram versus expected number of big perturbations
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_bigp/(2*nbinsd)) : (maxavnumber_bigp/nbinsd) : ...
    (maxavnumber_bigp-(maxavnumber_bigp/(2*nbinsd)));
bar(x,fr_blambdas(:,1));
xlim([0 maxavnumber_bigp]);
xlabel('{\lambda} for largest perturbations'); ylabel('freq');

[a,h] = suplabel('Planet Histograms 3 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% sixth multi-panel figure for planet histograms (part 3, hab planets)
f = figure(27); clf('reset');
set (f, 'Position', [575 200 400 800]);

% histogram versus expected number of small perturbations
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_littlep/(2*nbinsd)) : (maxavnumber_littlep/nbinsd) : ...
    (maxavnumber_littlep-(maxavnumber_littlep/(2*nbinsd)));
bar(x,fr_llambdas(:,2));
xlim([0 maxavnumber_littlep]);
xlabel('{\lambda} for smaller perturbations'); ylabel('freq');

% histogram versus expected number of medium perturbations
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_midp/(2*nbinsd)) : (maxavnumber_midp/nbinsd) : ...
    (maxavnumber_midp-(maxavnumber_midp/(2*nbinsd)));
bar(x,fr_mlambdas(:,2));
xlim([0 maxavnumber_midp]);
xlabel('{\lambda} for mid-sized perturbations'); ylabel('freq');

% histogram versus expected number of big perturbations
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_bigp/(2*nbinsd)) : (maxavnumber_bigp/nbinsd) : ...
    (maxavnumber_bigp-(maxavnumber_bigp/(2*nbinsd)));
bar(x,fr_blambdas(:,2));
xlim([0 maxavnumber_bigp]);
xlabel('{\lambda} for largest perturbations'); ylabel('freq');

[a,h] = suplabel('Planet Histograms 3 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


%% 3. line plots comparing the two frequency distributions
%  (for all planets compared to for successful planets only)
%  Significant differences between the two indicate a postive or adverse
%  effect of the property on the chances of staying habitable for 3 By

% first multi-panel figure for planet pdfs
f = figure(28); clf('reset');
set (f, 'Position', [1100 200 400 800]);

% pdfs of distributions versus number of nodes
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 1:nnodes_max;
plot(x,fr_nodes(:,1),'-k^',x,fr_nodes(:,2),'-ro');
xlim([1 nnodes_max+1]);
xlabel('# nodes'); ylabel('probability');
legend('all','survivors', 'Location', 'best');

% pdfs of distributions versus number of stable attractors
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 0:nnodes_max;   % can have 0 stable attractors
plot(x,fr_attrs(:,1),'-k^',x,fr_attrs(:,2),'-ro');
xlim([-1 (nnodes_max/2+1)]);
xlabel('# stable attractors'); ylabel('probability');

% pdfs of distributions versus greatest stable attractor width
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(2*nbinsd)) : (Trange/nbinsd) : ...
    (((2*nbinsd)-1)*Trange/(2*nbinsd));
plot(x,fr_widths(:,1),'-k^',x,fr_widths(:,2),'-ro');
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('probability');

% pdfs of distributions versus greatest stable attractor strength
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (frange/(4*nbinsd)) : (frange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*frange/(4*nbinsd));
plot(x,fr_strengths(:,1),'-k^',x,fr_strengths(:,2),'-ro');
xlim([0 (frange/2.0)]);
xlabel('max. SA strength'); ylabel('probability');

% pdfs of distributions versus greatest stable attractor power
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
powmax = Trange*(frange/2.0);
x = (powmax/(2*nbinsd)) : (powmax/nbinsd) : (powmax-(powmax/(2*nbinsd)));
plot(x,fr_powers(:,1),'-k^',x,fr_powers(:,2),'-ro');
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('probability');

% pdfs of distributions versus left-right asymmetry of feedbacks
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
asymm_max = Trange*frange/2.0;
asymm_gap = 2.0*asymm_max/nbinsd;
x = (-asymm_max+(asymm_gap/2.0)) : asymm_gap : (asymm_max-(asymm_gap/2.0));
plot(x,fr_asymms(:,1),'-k^',x,fr_asymms(:,2),'-ro');
xlim([-asymm_max asymm_max]);
xlabel('asymmetry of feedbacks'); ylabel('probability');

[a,h] = suplabel('Planet PDFs 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet pdfs
f = figure(29); clf('reset');
set (f, 'Position', [1175 200 400 800]);

% pdfs of distributions versus trends
subplot(7,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
trendr = trendmax-trendmin;
x = (trendmin+(trendr/(2*nbinsd))) : (trendr/nbinsd) : ...
    (trendmax-(trendr/(2*nbinsd)));
plot(x,fr_trends(:,1),'-k^',x,fr_trends(:,2),'-ro');
xlim([trendmin trendmax]);
xlabel('imposed trend in dT/dt'); ylabel('probability');
legend('all','survivors', 'Location', 'best');

% pdfs of distributions versus potency of runaway feedbacks
subplot(7,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (0.0+(1.0/(2*nbinsd))) : (1.0/nbinsd) : ...
    (1.0-(1.0/(2*nbinsd)));
plot(x,fr_runaways(:,1),'-k^',x,fr_runaways(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('probability');

% pdfs of distributions versus positions of main stable attractor (first
% definition)
subplot(7,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
plot(x,fr_pos1s(:,1),'-k^',x,fr_pos1s(:,2),'-ro');
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('probability');

% pdfs of distributions versus distances of main stable attractor from
% midpoint (first definition)
subplot(7,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
plot(x,fr_dist1s(:,1),'-k^',x,fr_dist1s(:,2),'-ro');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('probability');

% pdfs of distributions versus positions of main stable attractor (second
% definition)
subplot(7,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
plot(x,fr_pos2s(:,1),'-k^',x,fr_pos2s(:,2),'-ro');
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('probability');

% pdfs of distributions versus distances of main stable attractor from
% midpoint (second definition)
subplot(7,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
plot(x,fr_dist2s(:,1),'-k^',x,fr_dist2s(:,2),'-ro');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('probability');

% A SPECIAL EXTRA ONE, FOR AVERAGE DURATIONS OF SOMETIMES VS NEVER
% SUCCESSFUL PLANETS 
subplot(7,1,7);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = max_duration/nbinsd;
x = (thisgap/2.0) : thisgap : (max_duration-(thisgap/2.0));
plot(x,fr_avdurations(:,1),'-k^',x,fr_avdurations(:,2),'-ro');
xlim([0.0 max_duration]);
xlabel('Average planet survival durations'); ylabel('probability');

[a,h] = suplabel('Planet PDFs 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for planet pdfs
f = figure(30); clf('reset');
set (f, 'Position', [1250 200 400 800]);

% pdfs of distributions versus expected number of smaller perturbations
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_littlep/(2*nbinsd)) : (maxavnumber_littlep/nbinsd) : ...
    (maxavnumber_littlep-(maxavnumber_littlep/(2*nbinsd)));
plot(x,fr_llambdas(:,1),'-k^',x,fr_llambdas(:,2),'-ro');
xlim([0 maxavnumber_littlep]);
xlabel('{\lambda} for smaller perturbations'); ylabel('probability');
legend('all','survivors', 'Location', 'best');

% pdfs of distributions versus expected number of mid-sized perturbations
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_midp/(2*nbinsd)) : (maxavnumber_midp/nbinsd) : ...
    (maxavnumber_midp-(maxavnumber_midp/(2*nbinsd)));
plot(x,fr_mlambdas(:,1),'-k^',x,fr_mlambdas(:,2),'-ro');
xlim([0 maxavnumber_midp]);
xlabel('{\lambda} for mid-sized perturbations'); ylabel('probability');

% pdfs of distributions versus expected number of larger perturbations
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (maxavnumber_bigp/(2*nbinsd)) : (maxavnumber_bigp/nbinsd) : ...
    (maxavnumber_bigp-(maxavnumber_bigp/(2*nbinsd)));
plot(x,fr_blambdas(:,1),'-k^',x,fr_blambdas(:,2),'-ro');
xlim([0 maxavnumber_bigp]);
xlabel('{\lambda} for larger perturbations'); ylabel('probability');

[a,h] = suplabel('Planet PDFs 3');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


%% 4. line plots showing the ratio of the two (the tau-statistic)
%  Values of about 1 indicate no effect of the property on the chances of a
%  planet (occasionally) remaining habitable for 3 By.
%  Values greater than 1 indicate a positive effect of the property on the
%  chances of a planet (occasionally) remaining habitable for 3 By.
%  Values less than 1 indicate a detrimental effect of the property on the
%  chances of a planet (occasionally) remaining habitable for 3 By.

% first multi-panel figure for planet ratios
f = figure(31); clf('reset');
set (f, 'Position', [1325 200 400 800]);

% ratios of distributions versus number of nodes
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 1:nnodes_max;
plot(x,ratio_nodes(:),'-bo');
xlim([1 nnodes_max+1]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('# nodes'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_nodes(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus number of stable attractors
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = 0:nnodes_max;   % can have 0 stable attractors
plot(x,ratio_attrs(:),'-bo');
xlim([-1 (nnodes_max/2+1)]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('# stable attractors'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_attrs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus greatest stable attractor width
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/nbinsd;
x = (thisgap/2.0) : thisgap : (Trange-(thisgap/2.0));
plot(x,ratio_widths(:),'-bo');
xlim([0 Trange]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. SA width'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_widths(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus greatest stable attractor strength
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (frange/(2*nbinsd));
x = (thisgap/2.0) : thisgap : ((frange/2.0)-(thisgap/2.0));
plot(x,ratio_strengths(:),'-bo');
xlim([0 (frange/2.0)]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. SA strength'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_strengths(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus greatest stable attractor power
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
powmax = Trange*(frange/2.0);
thisgap = powmax/nbinsd;
x = (thisgap/2.0) : thisgap : (powmax-(thisgap/2.0));
plot(x,ratio_powers(:),'-bo');
xlim([0 powmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. SA power'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_powers(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus left-right asymmetry of feedbacks
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
asymm_max = Trange*frange/2.0;
asymm_gap = 2.0*asymm_max/nbinsd;
x = (-asymm_max+(asymm_gap/2.0)) : asymm_gap : (asymm_max-(asymm_gap/2.0));
plot(x,ratio_asymms(:),'-bo');
xlim([-asymm_max asymm_max]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('asymmetry of feedbacks'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_asymms(nn)>4)
       text((x(nn)-(asymm_gap/3)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

[a,h] = suplabel('Planet ratios 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet ratios
f = figure(32); clf('reset');
set (f, 'Position', [1400 200 400 800]);

% ratios of distributions versus trends
subplot(7,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
trendr = trendmax-trendmin;
thisgap = trendr/nbinsd;
x = (trendmin+(thisgap/2.0)) : thisgap : (trendmax-(thisgap/2.0));
plot(x,ratio_trends(:),'-bo');
xlim([trendmin trendmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('imposed trend in dT/dt'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_trends(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus potency of runaway feedbacks
subplot(7,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (0.0+(thisgap/2.0)) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_runaways(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('runaway fraction (of T range)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_runaways(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus positions of main stable attractor
% (first definition)
subplot(7,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,ratio_pos1s(:),'-bo');
xlim([Tmin Tmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('position of main SA (def1)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_pos1s(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus distances of main stable attractor from
% midpoint (first definition)
subplot(7,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/(2*nbinsd);
x = (thisgap/2.0) : thisgap : ((Trange/2.0)-(thisgap/2.0));
plot(x,ratio_dist1s(:),'-bo');
xlim([0.0 Trange*0.55]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('offset of main SA (def1)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_dist1s(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus positions of main stable attractor
% (second definition)
subplot(7,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,ratio_pos2s(:),'-bo');
xlim([Tmin Tmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('position of main SA (def2)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_pos2s(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus distances of main stable attractor from
% midpoint (second definition)
subplot(7,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/(2*nbinsd);
x = (thisgap/2.0) : thisgap : ((Trange/2.0)-(thisgap/2.0));
plot(x,ratio_dist2s(:),'-bo');
xlim([0.0 Trange*0.55]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('offset of main SA (def2)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_dist2s(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

[a,h] = suplabel('Planet ratios 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for planet ratios
f = figure(33); clf('reset');
set (f, 'Position', [1475 200 400 800]);

% ratios of distributions versus expected number of smaller perturbations
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = maxavnumber_littlep/nbinsd;
x = (thisgap/2.0) : thisgap : (maxavnumber_littlep-(thisgap/2.0));
plot(x,ratio_llambdas(:),'-bo');
xlim([0 maxavnumber_littlep]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('{\lambda} for smaller perturbations'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_llambdas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus expected number of mid-sized perturbations
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = maxavnumber_midp/nbinsd;
x = (thisgap/2.0) : thisgap : (maxavnumber_midp-(thisgap/2.0));
plot(x,ratio_mlambdas(:),'-bo');
xlim([0 maxavnumber_midp]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('{\lambda} for mid-sized perturbations'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_mlambdas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of distributions versus expected number of larger perturbations
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = maxavnumber_bigp/nbinsd;
x = (thisgap/2.0) : thisgap : (maxavnumber_bigp-(thisgap/2.0));
plot(x,ratio_blambdas(:),'-bo');
xlim([0 maxavnumber_bigp]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('{\lambda} for larger perturbations'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_blambdas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

[a,h] = suplabel('Planet ratios 3');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% make the axes labels be normal again (font size 10)
set(0, 'DefaultAxesFontSize', 10);
