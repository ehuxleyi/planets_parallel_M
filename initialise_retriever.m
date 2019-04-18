% script to carry out various initialisation tasks before getting results
% 
% do several things before results can be retrieved after a simulation has
% finished executing. For instance, declare variables, set up arrays and
% structures
%--------------------------------------------------------------------------

% close all windows, clear all memory  
clear all; close all; clc;

% define various constants and parameter values
set_constants;

% initialise arrays
task_planets = double(zeros([ntasks ntaskruns])); % list of planets for each task
task_runs    = double(zeros([ntasks ntaskruns])); % list of runs for each task

% if necessary, create the directory in which to store all of the results
if ~exist('results', 'dir')
    mkdir('results');
end
sname = sprintf('results/%s', savename);
if ~exist(sname, 'dir')
    mkdir(sname);
end
