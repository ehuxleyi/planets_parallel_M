% script to delete jobs from the cluster
%--------------------------------------------------------------------------

% set up a cluster object
ct = parcluster;

% find user's jobs
myjobs = findJob(ct);

% delete them
delete(myjobs);
clear myjobs;
