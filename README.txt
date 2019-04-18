To run this parallel version of the Planets model follow these steps:

1. use File Explorer, 7-zip or similar to extract the contents of 
   "planets_parallel_M.z" in a directory

2. start MATLAB

3. in MATLAB, change the directory to where you extracted the files to

4. enter the command "ts_master" in MATLAB's command window

5. when the tasks have finished running, type "ts_retrieve" to fetch the 
   results then "ts_analyse" to analyse them


New users should run the serial version first. This parallel version is for 
the execution of large ensembles of planets. A set of plots showing the 
results of the whole simulation are produced at the end of step 5 above, 
but the temperature histories of individual planets are not shown on screen 
as they are being computed. 

Parameter values and settings can be edited in the file 'set_constants.m',
including the number of planets and reruns in the simulation.

This parallel code uses MATLAB Distributed Computing Server (MDCS). 
The simulation is split up into separate tasks, each of which is executed 
independently on a different processor of a computer cluster or single PC. 
In order to run large simulations efficiently, it may be necessary to alter 
cluster properties such as 'walltime' and 'number of nodes' in MATLAB's 
Cluster Profile Manager.

You are free to use, modify and share the code in this directory according 
to the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 License
(https://creativecommons.org/licenses/by-nc-sa/4.0/)