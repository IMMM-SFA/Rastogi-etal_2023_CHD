This directory contains supporting code used in calculating extremes for Rastogi, et al. (2023).

This current directory contains code necessary to identify heatwave days for each CMIP6, PRISM and ERA5 data. See manuscript for additional details.

----------Scripts----------

calculate_t95_JJA.ncl
	- calculates 95th percentile of daily maximum temperature (t95) during the summer months
calculate_numdays_abovet95.ncl
	- identifies days with daily maximum temperature above t95
calculate_heatwave_days.ncl  
	- identifies heatwave days

----------Datasets----------

Parameter-elevation Relationships on Independent Slopes Model (PRISM):
        - Dataset: PRISM monthly averaged variables from 1981-2020
        - Variables: 2-meter temperature and total precipitation
        - Download: Via the website https://prism.oregonstate.edu/recent/. Details in the PRISM_download.py script in PRISM_analysis/ directory.

ECMWF Reanalysis v5 - Land (ERA5-LAND):
        - Dataset: ERA5-LAND monthly averaged variables from 1981-2020
        - Variables: 2-meter temperature and total precipitation
        - Download: Via the Copernicus Climate Change Service (C3S) API. Details in the ERA5_download.py script in ERA5_analysis/ directory.

Coupled Model Intercomparison Project v6 (CMIP6) Historical / SSP585(future) Data:
        - Dataset: Monthly averaged model output from 1981-2014. See paper for list of models used in this analysis.
        - Variables: 2-meter temperature and total precipitation
        - Download: Via World Climate Research Programme (WCRP) https://esgf-node.llnl.gov/search/cmip6/

