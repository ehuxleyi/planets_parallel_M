% script to read and check information from the header file
%--------------------------------------------------------------------------

hname = sprintf('results/%s/header.mat', savename);
if ~exist(hname, 'file')
    error('  ERROR: NO HEADER (%s)\n\n', hname);
else
    load(hname);   % should read in svname, np, nr, nt
    if ~strcmp(svname, savename)
        error('  ERROR: SIMULATION NAMES DO NOT AGREE (%s) (%s)\n\n', ...
            svname, savename);
    end
    if (np ~= nplanets)
        error('  ERROR: NUMBERS OF PLANETS DO NOT AGREE (%d) (%d)\n\n', ...
            np, nplanets);
    end
    if (nr ~= nreruns)
        error('  ERROR: NUMBERS OF RUNS DO NOT AGREE (%d) (%d)\n\n', ...
            nr, nreruns);
    end
end
