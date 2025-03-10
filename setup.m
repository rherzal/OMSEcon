% Add to path all directories required for approximate RL to work

crt = pwd;
addpath(genpath(pwd));
% try finding lib as subdir...
addpath(genpath([pwd '\lib']));
% ... and/or as sibling directory
slashind = strfind(crt, '\');
if ~isempty(slashind) && (slashind(end) > 1),
    parent = crt(1:slashind(end)-1);
    addpath(genpath([parent '\lib']));
end;

% uncomment to save the path for future use in other Matlab sessions
% savepath;
