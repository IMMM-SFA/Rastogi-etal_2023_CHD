This directory contains supporting code for analysis presented in Rastogi et al.,2023.

This current directory contains code necessary to calculate drought events using the Standardized Precipitation Index (SPI) and Standardized Precipitation-Evapotranspiration Index (SPEI) for each PRISM, CMIP6, and ERA5 data. See manuscript for additional details.

----------Sub-directories----------

CMIP6_hist_analysis:  
	- contains all necessary scripts to perform drought analysis on CMIP6 historical dataset
CMIP6_ssp585_analysis:  
	- contains all necessary scripts to perform drought analysis on CMIP6 ssp585 dataset 
PRISM_analysis:
	- contains all necessary scripts to perform drought analysis on PRISM dataset
ERA5_analysis:
	- contains all necessary scripts to perform drought analysis on ERA5 dataset
compute_scripts:  
	- functions called in drought metric scripts 
drought_metric_definitions.txt:
	- detailed definitions of each drough metric computed in this analysis
input_data:
	- empty directories intended to hold input data files
updated_climate_indices:
	- modified versions of the scripts in the python climate_indices module (Adams 2017)
		- needed to process CMIP6 ssp585 drought indices
		- climate_indices can be downloaded in its original form here > https://climate-indices.readthedocs.io/en/latest/#download-the-code

----------Datasets----------

Parameter-elevation Relationships on Independent Slopes Model (PRISM): 
	- Dataset: PRISM monthly averaged variables from 1981-2020
	- Variables: 2-meter temperature and total precipitation
	- Download: Via the website https://prism.oregonstate.edu/recent/. Details in the PRISM_download.py script in PRISM_analysis/ directory.

ECMWF Reanalysis v5 - Land (ERA5-LAND): 
	- Dataset: ERA5-LAND monthly averaged variables from 1981-2020
	- Variables: 2-meter temperature and total precipitation
	- Processing: Download hourly data and process to generate monthly averages
	- Download: Via the Copernicus Climate Change Service (C3S) API. Details in the ERA5_download.py script in ERA5_analysis/ directory.

Coupled Model Intercomparison Project v6 (CMIP6) Historical and SSP585(future) Data:
	- Dataset: Monthly averaged model output from 1981-2014 and 2015-2100. See paper for list of models used in this analysis.
	- Variables: 2-meter temperature and total precipitation
	- Download: Via World Climate Research Programme (WCRP) https://esgf-node.llnl.gov/search/cmip6/ 


----------Recreating this analysis----------

See README files in directories PRISM_analysis/ ERA5_analysis/ CMIP6_hist_analysis/ and CMIP6_ssp585_analysis/ for detailed steps to recreate this analysis for each dataset.


----------Questions----------

For questions about the code, please contact Jared Trok (trok@stanford.edu).

