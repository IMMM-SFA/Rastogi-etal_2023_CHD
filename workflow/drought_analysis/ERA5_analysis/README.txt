--------------------------------------------------------------------
-------------------------ERA5 Workflow------------------------------
--------------------------------------------------------------------


To perform the ERA5 drought analysis, follow the steps below:


---------- download and preprocess data -----------

(1)  ERA5_download.py 
	- downloads monthly ERA5 2m_temperature and total_precipitation data into input_data folders: 
		"/drought_analysis/input_data/ERA5/monthly/<2t/tp/>" 

(2)  ERA5_regrid_to_1deg.sh
	- regrids the ERA5 data files to a 1 degree grid via bilinear interpolation (360x180)
		* renames latitude/longitude variables with lat/lon respectively
		* uses the grid defined in /ERA5_analysis/gridfile.txt
	- script requires the Climate Data Operators (CDO) 



---------- compute drought indices ----------

** These next four scripts require the python climate_indices module which can be downloaded at
https://climate-indices.readthedocs.io/en/latest/#download-the-code

(3)  ERA5_process_pet.sh
	- computes ERA5 Potential Evapotranspiration
(4)  ERA5_process_spi.sh
	- computes ERA5 Standardized Precipitation Index
(5)  ERA5_process_spei.sh
	- computes ERA5 Standardized Precipitation-Evapotranspiration Index

Notes: 
--> edit above scripts to determine output directories
--> output filenames: 
	"ERA5_CONUS_1deg_monthly_198101_202012_pet_thornthwaite.nc"
	"ERA5_CONUS_1deg_monthly_198101_202012_spi_gamma_<##>.nc"
	"ERA5_CONUS_1deg_monthly_198101_202012_spei_gamma_<##>.nc"
--> Summary of computation for SPI/SPEI:
      1. For each grid cell, the calibration data is fit to a gamma distribution.
      2. We then compute probabilities for each time step based on the grid cells unique gamma distribution.
      3. These values are then standardized to the equivalent values on a normal distribution that occur with the same probability.
--> PET is used in the computation of SPEI and must therefore be created first.
--> SPI/SPEI scripts are currently set to compute values using a 6-month timescale with calibration period 01/1981-12/2014


---------- calculate drought metrics ----------

(6)  Edit "ERA5_set_paths.m" script to define desired input/output paths for the following scripts

(7) ERA5_drought_metrics_numbered.m
	- computes ERA5 drought metric files for all indices
		--> outputs numeric arrays with chronological numbering of drought events at each gridcell
	
Notes:
--> outputs filenames "ERA5_CONUS_monthly_198101_202012_<spi/sri/spei>_<##>_drought_metrics_numbered.nc"

*For a description of different variables created by the drought metric scripts, refer to drought_metric_definitions.txt



---------- References ----------

Schulzweida, Uwe. (2021, October 31). CDO User Guide (Version 2.0.0). Zenodo. http://doi.org/10.5281/zenodo.5614769

Adams, J. (2017, May). climate_indices, an open source Python library providing reference implementations of commonly used climate indices. https://github.com/monocongo/climate_indices


