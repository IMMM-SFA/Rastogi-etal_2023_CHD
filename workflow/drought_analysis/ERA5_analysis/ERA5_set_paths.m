% edit the following paths as needed
%% Set paths

% to compute_scripts folder
to_compute_scripts = '... /compute_scripts/'; 

% to ERA5 tp data used for spi/spei calculations
to_tp = '... /ERA5/monthly/tp/';

% to ERA5 spi/spei files 
to_spi  = '... /drought_indices/ERA5/spi/';
to_spei = '... /drought_indices/ERA5/spei/';

% to desired ERA5 spi/spei output files 
to_spi_met  = '... /drought_indices/ERA5/spi/';
to_spei_met = '... /drought_metric/ERA5/spei/';


%% Add Paths
addpath(to_compute_scripts);
addpath(to_tp);
addpath(to_spi);
addpath(to_spei);
addpath(to_spi_met);
addpath(to_spei_met);

