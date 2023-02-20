-----------------------------------------
------ Historical CMIP6 Workflow --------
-----------------------------------------


Run the following scripts in order to perform the CMIP6 drought analysis for the historical period.


----------Data preparation----------

(1)  CMIP6_hist_flux_to_depth.m
	- Converts monthly CMIP6 precipitation (pr) data from kg/m/s to mm/month

(2)  CMIP6_hist_remove_negatives.sh
	- Replaces any negative values for pr with zeros.

(3)  CMIP6_hist_remove_non_matching_times.sh
	- Ensures that the time variable in CMIP6 historical pr and temperature (tas) files used in the computation of SPEI are identical. 	



----------Process drought indices----------

** These next four scripts require the python climate_indices module which can be downloaded at 
https://climate-indices.readthedocs.io/en/latest/#download-the-code

(4)  CMIP6_hist_process_pet.sh 
	- Computes ERA5 Potential Evapotranspiration
(5)  CMIP6_hist_process_spi.sh
	- Computes ERA5 Standardized Precipitation Index
(6)  CMIP6_hist_process_spei.sh
	- Computes ERA5 Standardized Precipitation-Evapotranspiration Index


Notes:

- Summary of computation:
	1. For each grid cell, the calibration data is fit to a gamma distribution. 
	2. We then compute probabilities for each time step based on the grid cells unique gamma distribution.
	3. These values are then standardized to the equivalent values on a normal distribution that occur with the same probability.
- These CMIP6 process scripts will output files with filenames: 
		"tas_Amon_<cmip6_model_details>_pet_thornthwaite.nc"
		"pr_Amon_<cmip6_model_details>_spi_gamma_<##>.nc"
		"pr_Amon_<cmip6_model_details>_spei_gamma_<##>.nc"

- PET is used in the computation of SPEI and must therefore be created first.
- SPI/SPEI calculations are currently set to compute values at 6-month scales with calibration period 01/1981-12/2014


----------Set paths and path variables---------

(7)  CMIP6_hist_set_paths.sh
        - Edit this script to set paths and path variables to be used in the drought metric scripts below


----------Process drought metrics----------

(8) CMIP6_hist_drought_metrics_numbered_spi.m
(9) CMIP6_hist_drought_metrics_numbered_spei.m
	- Above scripts produce drought metric files for all indices and timescales


----------Notes----------

- These above scripts will output into paths defined in CMIP6_hist_set_paths.m
	with filenames: 
		"pr_Amon_<cmip6_model_details>_spi_gamma_<##>_drought_metrics_numbered.nc"  
		"pr_Amon_<cmip6_model_details>_spei_gamma_<##>_drought_metrics_numbered.nc" 
			
*For a description of different variables created by the drought metric scripts, refer to drought_metric_definitions.txt



---------- References ----------

Schulzweida, Uwe. (2021, October 31). CDO User Guide (Version 2.0.0). Zenodo. http://doi.org/10.5281/zenodo.5614769

Adams, J. (2017, May). climate_indices, an open source Python library providing reference implementations of commonly used climate indices. https://github.com/monocongo/climate_indices


