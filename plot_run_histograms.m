% script to produce 8 figures showing frequency distributions for runs
% 
% Histograms show the frequency distributions among runs of various
% properties (for instance, how how often different sizes of maximum
% perturbation occur). Line plots of frequency distributions are also
% produced.
% 
% The following types of plot are produced (for each property):
% 1. histogram of frequency distribution for all runs
% 2. histogram of frequency distribution for successful runs only
% 3. line plot comparing the two distributions
% 4. line plot showing the ratio of the two (the tau-statistic)
% -------------------------------------------------------------------------


%% initialisation
% make the axes labels be small (font size 9) for the histograms
set(0, 'DefaultAxesFontSize', 9);


%% 1. histograms of frequency distribution for all runs, and
%  2. histograms of frequency distribution for successful runs only

% first multi-panel figure for run histograms (part 1, all runs)
f = figure(42); clf('reset');
set (f, 'Position', [500 200 400 800]);

% histogram versus maximum potential perturbation if run goes all the way
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
prange = 2.0*exp_pmax;
thisgap = prange/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxpotps(:,1));
xlim([-exp_pmax exp_pmax]);
xlabel('max. potential perturbation'); ylabel('freq.');

% histogram versus maximum experienced (actual) perturbation 
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
prange = 2.0*exp_pmax;
thisgap = prange/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxactps(:,1));
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('freq.');

% histogram versus initial (starting) temperature
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_initTs(:,1));
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('freq.');

% histogram versus standard deviation of temperature during the run
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (25/(2*nbinsd)) : (25/nbinsd) : (25-(25/(2*nbinsd)));
bar(x,fr_stdTs(:,1));
xlim([0 25]);
xlabel('standard deviation of T'); ylabel('freq.');

% histogram versus average trend (from line-fitting) in observed
% temperature over time
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (-90+(180/(2*nbinsd))) : (180/nbinsd) : (90-(180/(2*nbinsd)));
bar(x,fr_trendTs(:,1));
xlim([-90 90]);
trendtext = sprintf('slope of actual trend in T (%cC per 10My, as an angle)', char(176));
xlabel(trendtext); ylabel('freq.');

% histogram versus mode (most frequent) temperature during run
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = ((Tmin-10)+((Trange+20)/(2*nbinsd))) : ((Trange+20)/nbinsd) : ...
    ((Tmax+10)-((Trange+20)/(2*nbinsd)));
bar(x,fr_modeTs(:,1));
xlim([(Tmin-10) (Tmax+10)]);
xlabel('mode T'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Histograms 1 (for all runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run histograms (part 1, hab runs)
f = figure(43); clf('reset');
set (f, 'Position', [600 200 400 800]);

% histogram versus maximum perturbation if run goes all the way
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxpotps(:,2));
xlim([-exp_pmax exp_pmax]);
xlabel('max. potential perturbation'); ylabel('freq.');

% histogram versus maximum experienced (actual) perturbation 
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxactps(:,2));
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('freq.');

% histogram versus initial (starting) temperature
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_initTs(:,2));
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('freq.');

% histogram versus standard deviation of temperature during the run
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (25/(2*nbinsd)) : (25/nbinsd) : (25-(25/(2*nbinsd)));
bar(x,fr_stdTs(:,2));
xlim([0 25]);
xlabel('standard deviation of T'); ylabel('freq.');

% histogram versus average trend (from line-fitting) in observed
% temperature over time
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (-90+(180/(2*nbinsd))) : (180/nbinsd) : (90-(180/(2*nbinsd)));
bar(x,fr_trendTs(:,2));
xlim([-90 90]);
xlabel(trendtext); ylabel('freq.');

% histogram versus mode (most frequent) temperature during run
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = ((Tmin-10)+((Trange+20)/(2*nbinsd))) : ((Trange+20)/nbinsd) : ...
    ((Tmax+10)-((Trange+20)/(2*nbinsd)));
bar(x,fr_modeTs(:,2));
xlim([(Tmin-10) (Tmax+10)]);
xlabel('mode T'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Histograms 1 (for hab runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for run histograms (part 2, all runs)
f = figure(44); clf('reset');
set (f, 'Position', [700 200 400 800]);

% histogram versus fractions of time spent outside any SAs
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeouts(:,1));
xlim([0 1]);
xlabel('fraction of time outwith SAs'); ylabel('freq.');

% histogram versus fractions of time spent within SAs
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timesas(:,1));
xlim([0 1]);
xlabel('fraction of time within SAs'); ylabel('freq.');

% histogram versus fractions of time spent within the most powerful SA
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timepowsas(:,1));
xlim([0 1]);
xlabel('fraction of time within most powerful SA'); ylabel('freq.');

% histogram versus fractions of time spent within the most occupied SA
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeoccsas(:,1));
xlim([0 1]);
xlabel('fraction of time within most occupied SA'); ylabel('freq.');

% histogram versus run durations
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (3.0/(2*nbinsd)) : (3.0/nbinsd) : (((2*nbinsd)-1)*3.0/(2*nbinsd));
bar(x,fr_durations);
xlim([0 (max_duration/1e6)]);
xlabel('run duration (By)'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Histograms 2 (for all runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fourth multi-panel figure for run histograms (part 2, hab runs)
f = figure(45); clf('reset');
set (f, 'Position', [800 200 400 800]);

% histogram versus fractions of time spent outside any SAs
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeouts(:,2));
xlim([0 1]);
xlabel('fraction of time outwith SAs'); ylabel('freq.');

% histogram versus fractions of time spent within SAs
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timesas(:,2));
xlim([0 1]);
xlabel('fraction of time within SAs'); ylabel('freq.');

% histogram versus fractions of time spent within the most powerful SA
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timepowsas(:,2));
xlim([0 1]);
xlabel('fraction of time within most powerful SA'); ylabel('freq.');

% histogram versus fractions of time spent within the most occupied SA
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeoccsas(:,2));
xlim([0 1]);
xlabel('fraction of time within most occupied SA'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Histograms 2 (for hab runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


%% 3. line plots comparing the two frequency distributions
%  (for all runs compared to for successful runs only)
%  Significant differences between the two indicate a postive or adverse
%  effect of the property on the chances of staying habitable for 3 By

% first multi-panel figure for run pdfs
f = figure(46); clf('reset');
set (f, 'Position', [1300 200 400 800]);

% pdfs of maximum potential perturbation if run goes all the way
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,fr_maxpotps(:,1),'-k^',x,fr_maxpotps(:,2),'-ro');
xlim([-exp_pmax exp_pmax]);
legend('all', 'survivors', 'Location', 'best');
xlabel('max. potential perturbation'); ylabel('probability');

% pdfs of maximum perturbation actually encountered up until the run ended
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,fr_maxactps(:,1),'-k^',x,fr_maxactps(:,2),'-ro');
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('probability');

% pdfs of initial (starting) temperature
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,fr_initTs(:,1),'-k^',x,fr_initTs(:,2),'-ro');
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('probability');

% pdfs of standard deviation of temperature during the run
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 25.0/nbinsd;
x = (thisgap/2.0) : thisgap : (25.0-(thisgap/2.0));
plot(x,fr_stdTs(:,1),'-k^',x,fr_stdTs(:,2),'-ro');
xlim([0.0 25.0]);
xlabel('standard deviation of T'); ylabel('probability');

% pdfs of average trend over time (from line-fitting) of observed
% temperature
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 180.0/nbinsd;
x = (-90.0+(thisgap/2.0)) : thisgap : (90.0-(thisgap/2.0));
plot(x,fr_trendTs(:,1),'-k^',x,fr_trendTs(:,2),'-ro');
xlim([-90.0 90.0]);
xlabel(trendtext); ylabel('probability');

% pdfs of mode (most frequent) temperature during run
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (Trange+20.0)/nbinsd;
x = ((Tmin-10)+(thisgap/2.0)) : thisgap : ((Tmax+10)-(thisgap/2.0));
plot(x,fr_modeTs(:,1),'-k^',x,fr_modeTs(:,2),'-ro');
xlim([(Tmin-10) (Tmax+10)]);
xlabel('mode T'); ylabel('probability');

[a,h] = suplabel('Run PDFs 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run pdfs
f = figure(47); clf('reset');
set (f, 'Position', [1400 200 400 800]);

% pdfs of fractions of time spent outside any SAs
subplot(5,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timeouts(:,1),'-k^',x,fr_timeouts(:,2),'-ro');
xlim([0.0 1.0]);
legend('all', 'survivors', 'Location', 'best');
xlabel('fraction of time outwith SAs'); ylabel('probability');

% pdfs of fractions of time spent within SAs
subplot(5,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timesas(:,1),'-k^',x,fr_timesas(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('fraction of time within SAs'); ylabel('probability');

% pdfs of fractions of time spent within the most powerful SA
subplot(5,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timepowsas(:,1),'-k^',x,fr_timepowsas(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('fraction of time within most powerful SA'); ylabel('probability');

% pdfs of fractions of time spent within the most occupied SA
subplot(5,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timeoccsas(:,1),'-k^',x,fr_timeoccsas(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('fraction of time within most occupied SA'); ylabel('probability');

% pdfs of run durations
subplot(5,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (max_duration/1e6)/nbinsd;
x = (thisgap/2.0) : thisgap : ((max_duration/1e6)-(thisgap/2.0));
plot(x,fr_durations,'-k^');
xlim([0.0 (max_duration/1e6)]);
xlabel('run duration (By)'); ylabel('probability');

[a,h] = suplabel('Run PDFs 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


%% 4. line plots showing the ratio of the two (the tau-statistic)
%  Values of about 1 indicate no effect of the property on the chances of a
%  run remaining habitable for 3 By.
%  Values greater than 1 indicate a positive effect of the property on the
%  chances of a run remaining habitable for 3 By.
%  Values less than 1 indicate a detrimental effect of the property on the
%  chances of a run remaining habitable for 3 By.

% first multi-panel figure for run ratios
f = figure(48); clf('reset');
set (f, 'Position', [1300 200 400 800]);

% ratios of maximum potential perturbation if run goes all the way
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,ratio_maxpotps(:),'-bo');
xlim([-exp_pmax exp_pmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. potential perturbation'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_maxpotps(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

% ratios of maximum perturbation actually encountered up until the run ended
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,ratio_maxactps(:),'-bo');
xlim([-exp_pmax exp_pmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. actual perturbation'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_maxactps(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

% ratios of initial (starting) temperature
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,ratio_initTs(:),'-bo');
xlim([Tmin Tmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('initial T'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_initTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

% ratios of standard deviation of temperature during the run
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 25.0/nbinsd;
x = (thisgap/2.0) : thisgap : (25.0-(thisgap/2.0));
plot(x,ratio_stdTs(:),'-bo');
xlim([0.0 25.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('standard deviation of T'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_stdTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

% ratios of average trend over time (from line-fitting) of observed
% temperature
subplot(6,1,5);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 180.0/nbinsd;
x = (-90.0+(thisgap/2.0)) : thisgap : (90.0-(thisgap/2.0));
plot(x,ratio_trendTs(:),'-bo');
xlim([-90.0 90.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel(trendtext); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_trendTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of mode (most frequent) temperature during run
subplot(6,1,6);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = (Trange+20.0)/nbinsd;
x = ((Tmin-10)+(thisgap/2.0)) : thisgap : ((Tmax+10)-(thisgap/2.0));
plot(x,ratio_modeTs(:),'-bo');
xlim([(Tmin-10) (Tmax+10)]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('mode T'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_modeTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

[a,h] = suplabel('Run ratios 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run ratios
f = figure(49); clf('reset');
set (f, 'Position', [1400 200 400 800]);

% ratios of fractions of time spent outside any SAs
subplot(6,1,1);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timeouts(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]); 
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time outwith SAs'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timeouts(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');; 
   end
end
 
% ratios of fractions of time spent within SAs
subplot(6,1,2);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timesas(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time within SAs'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timesas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

% ratios of fractions of time spent within the most powerful SA
subplot(6,1,3);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timepowsas(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time within most powerful SA'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timepowsas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end
end

% ratios of fractions of time spent within the most occupied SA
subplot(6,1,4);
s = get(gca, 'Position');
set(gca, 'Position', [s(1), s(2)+0.06, s(3), s(4)*0.75]); % prevent overlap
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timeoccsas(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time within most occupied SA'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timeoccsas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end
end

[a,h] = suplabel('Run ratios 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% make the axes labels be normal again (font size 10)
set(0, 'DefaultAxesFontSize', 10);
