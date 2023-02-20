%% Add precipitation and runoff data to path
addpath('...'); %% add path to CMIP6_hist_set_paths.m
CMIP6_hist_set_paths;

%% Run unit change on CMIP6 hist historical dataset
scenario = 'historical';
compute_unit_change;

