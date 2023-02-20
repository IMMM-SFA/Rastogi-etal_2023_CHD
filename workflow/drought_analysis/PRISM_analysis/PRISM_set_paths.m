% edit the following paths as needed
%% Set paths

% to compute_scripts folder
to_compute_scripts = '... /compute_scripts/'; 

% to PRISM tp data used for spi/spei calculations
to_tp = '... /PRISM/monthly/tp/';

% to PRISM spi/spei files
to_spi  = '... /drought_indices/PRISM/spi/';
to_spei = '... /drought_indices/PRISM/spei/';

% to desired PRISM spi/spei output files
to_spi_met  = '... /drought_indices/PRISM/spi/';
to_spei_met = '... /drought_metric/PRISM/spei/';


%% Add Paths
addpath(to_compute_scripts);
addpath(to_tp);
addpath(to_spi);
addpath(to_spei);
addpath(to_spi_met);
addpath(to_spei_met);

