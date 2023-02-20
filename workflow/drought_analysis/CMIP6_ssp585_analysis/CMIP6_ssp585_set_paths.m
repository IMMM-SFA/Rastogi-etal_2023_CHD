% edit the following paths as needed
%% Set paths

% to compute_script folder
to_compute_scripts = '... /compute_scripts/'; 

% to ssp585 CMIP6 pr and mrro data used for spi/spei calculations
to_pr = '... /CMIP6_ssp585/monthly/pr/'; 
to_pr_spei = '... /CMIP6_ssp585/monthly/pr/spei'; 
% ^ it proves useful to have a separate folder for pr files used in spei calculations since some of those pr files might need to have their time variables edited in order to compute spei 

% to ssp585 CMIP6 spi/spei files
to_spi  = '... /drought_indices/CMIP6_ssp585/spi/';
to_spei = '... /drought_indices/CMIP6_ssp585/spei/'; 

% to desired ssp585 CMIP6 spi/spei output files
to_spi_met  = '... /drought_indices/CMIP6_ssp585/spi/';
to_spei_met = '... /drought_metric/CMIP6_ssp585/spei/';


%% Add Paths
addpath(to_compute_scripts);
addpath(to_pr);
addpath(to_pr_spei);
addpath(to_spi);
addpath(to_spei);
addpath(to_spi_met);
addpath(to_spei_met);

