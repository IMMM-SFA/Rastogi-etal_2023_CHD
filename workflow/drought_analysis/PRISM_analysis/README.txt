--------------------------------------------------------------------
-------------------------PRISM Analysis------------------------------
--------------------------------------------------------------------


To perform the PRISM drought analysis, follow the steps below:


---------- download and preprocess data -----------

(1)  PRISM_download.py 
	- downloads monthly PRISM 2m_temperature and total_precipitation data into input_data folders: 
		"/drought_analysis/input_data/PRISM/monthly/<2t/tp/>" 

(2)  PRISM_regrid_to_1deg.sh
	- regrids the PRISM data files to a 1 degree grid via bilinear interpolation (360x180)
		* renames latitude/longitude variables with lat/lon respectively
		* uses the grid defined in /PRISM_analysis/gridfile.txt
	- script requires the Climate Data Operators (CDO) 



---------- compute drought indices ----------

** These next four scripts require the python climate_indices module which can be downloaded at
https://climate-indices.readthedocs.io/en/latest/#download-the-code

(3)  PRISM_process_pet.sh
	- computes PRISM Potential Evapotranspiration
(4)  PRISM_process_spi.sh
	- computes PRISM Standardized Precipitation Index
(5)  PRISM_process_spei.sh
	- computes PRISM Standardized Precipitation-Evapotranspiration Index

Notes: 
--> edit above scripts to determine output directories
--> output filenames: 
	"PRISM_CONUS_1deg_monthly_198101_202012_pet_thornthwaite.nc"
	"PRISM_CONUS_1deg_monthly_198101_202012_spi_gamma_<##>.nc"
	"PRISM_CONUS_1deg_monthly_198101_202012_spei_gamma_<##>.nc"
--> Summary of computation for SPI/SPEI:
	1. For each grid cell, the calibration data is fit to a gamma distribution.
       	2. We then compute probabilities for each time step based on the grid cells unique gamma distribution.
       	3. These values are then standardized to the equivalent values on a normal distribution that occur with the same probability.
--> PET is used in the computation of SPEI and must therefore be created first.
--> SPI/SPEI scripts are currently set to compute values at 6 month scales with calibration period 01/1981-12/2014


---------- calculate drought metrics ----------

(6)  Edit "PRISM_set_paths.m" script to define desired input/output paths for the following scripts

(7) PRISM_drought_metrics_numbered.m
	- computes PRISM drought metric files for all indices
		--> "_numbered" suffix signifies drought numbering at each grid cell for all metrics
		--> outputs numeric arrays with chronological numbering of drought events
	
Notes:
--> outputs filenames "PRISM_CONUS_monthly_198101_202012_<spi/spei>_<##>_drought_metrics_numbered.nc"

*For a description of different variables created by the drought metric scripts, refer to drought_metric_definitions.txt



---------- References ----------

Schulzweida, Uwe. (2021, October 31). CDO User Guide (Version 2.0.0). Zenodo. http://doi.org/10.5281/zenodo.5614769

Adams, J. (2017, May). climate_indices, an open source Python library providing reference implementations of commonly used climate indices. https://github.com/monocongo/climate_indices


