[![DOI](https://zenodo.org/badge/)](https://doi.org/zenodo)

# Rastogi-etal\_2023\_tbd

**Historical evaluation and future projections of concurrent heatwave and drought extremes over the conterminous United States in CMIP6**

Deeksha Rastogi<sup>1,*</sup>, Jared Trok<sup>2,4</sup>, Nicholas Depsky<sup>3</sup>, Erwan Monier<sup>4</sup>, Andrew Jones<sup>5</sup>

<sup>1 </sup>  Computational Sciences and Engineering Division, Oak Ridge National Laboratory, Oak Ridge, TN

<sup>2 </sup> Department of Earth System Science, Stanford University, Stanford, CA

<sup>3 </sup> Energy and Resources Group, University of California, Berkeley, Berkeley, CA

<sup>4 </sup> Department of Land, Air and Water Resources, University of California, Davis, CA

<sup>5 </sup> Climate and Ecosystem Sciences Division, Lawrence Berkeley National Laboratory, Berkeley, CA



\* corresponding author: Deeksha Rastogi (rastogid@ornl.gov)

## Reproduce my experiment

1. Follow the steps outlined in workflow under heatwave analysis and drought analysis to identify heatwave and drought in CMIP6, PRISM and ERA5
1. Follow the steps in Figures to generate the plots

## Datasets

Parameter-elevation Relationships on Independent Slopes Model (PRISM):
        - Dataset: PRISM monthly averaged variables from 1981-2020
        - Variables: 2-meter temperature and total precipitation
        - Download: Via the website https://prism.oregonstate.edu/recent/. Details in the PRISM_download.py script in PRISM_analysis/ directory.

ECMWF Reanalysis v5 - Land (ERA5-LAND):
        - Dataset: ERA5-LAND daily and monthly averaged variables from 1981-2020
        - Variables: 2-meter temperature and total precipitation
        - Processing: Download hourly data and process to generate daily and monthly averages
        - Download: Via the Copernicus Climate Change Service (C3S) API. Details in the ERA5_download.py script in ERA5_analysis/ directory.

Coupled Model Intercomparison Project v6 (CMIP6) Historical and SSP585(future) Data:
        - Dataset: Daily and monthly averaged model output from 1981-2014 and 2015-2100. See paper for list of models used in this analysis.
        - Variables: 2-meter temperature and total precipitation
        - Download: Via World Climate Research Programme (WCRP) https://esgf-node.llnl.gov/search/cmip6/




