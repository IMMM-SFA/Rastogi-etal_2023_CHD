%% Add precipitation and runoff data to path
addpath('...'); %% add path to CMIP6_ssp585_set_paths.m
CMIP6_ssp585_set_paths;

%% Run unit change on CMIP6 ssp585 dataset
scenario = 'ssp585';
compute_unit_change;

