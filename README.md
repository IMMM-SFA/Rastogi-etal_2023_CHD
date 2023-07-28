[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7662363.svg)](https://doi.org/10.5281/zenodo.7662363)

# Rastogi-etal\_2023\_CHD

**Historical evaluation and future projections of concurrent heatwave and drought extremes over the conterminous United States in CMIP6**

Deeksha Rastogi<sup>1,*</sup>, Jared Trok<sup>2,4</sup>, Nicholas Depsky<sup>3</sup>, Erwan Monier<sup>4</sup>, Andrew Jones<sup>5</sup>

<sup>1 </sup>  Computational Sciences and Engineering Division, Oak Ridge National Laboratory, Oak Ridge, TN

<sup>2 </sup> Department of Earth System Science, Stanford University, Stanford, CA

<sup>3 </sup> Energy and Resources Group, University of California, Berkeley, Berkeley, CA

<sup>4 </sup> Department of Land, Air and Water Resources, University of California, Davis, CA

<sup>5 </sup> Climate and Ecosystem Sciences Division, Lawrence Berkeley National Laboratory, Berkeley, CA



\* corresponding author: Deeksha Rastogi (rastogid@ornl.gov)

## Abstract
Individually, both droughts and heatwaves can have severe impacts on human and natural systems. But when these two climate extremes occur concurrently in a given region, their compound impacts are often more pronounced. As global climate models (GCMs) improve in both their spatiotemporal resolution and representation of complex climate processes, they are increasingly used to study future changes in these extremes and associated regional impacts. However, GCM selection for such impact assessments is generally based on historical performance and/or future mean changes, without considering individual or compound extremes. In contrast, this study evaluates historical performance and projected changes in heatwaves, droughts, and compound heatwave-droughts using an ensemble of CMIP6 GCMs across the conterminous United States (CONUS). We also investigate inter-model differences in the projected changes that are associated with various characteristics of extremes and the choice of drought indices. The largest changes in the frequency of compound extremes are projected over Southwest, South Central and parts of Southeast while the smallest changes are projected over the Northeast. We find substantial differences in these projected changes based on the choice of drought indices as well as large variability among the GCMs. This study provides important insights for the interpretation and selection of GCMs for future assessment studies that is crucial for the development of regional adaptation strategies in the face of climate change.


## Reproduce my experiment

1. Follow the steps outlined in workflow under heatwave analysis and drought analysis to identify heatwave and drought in CMIP6, PRISM and ERA5
2. Follow the steps in Figures to generate the plots

## Datasets

1. Parameter-elevation Relationships on Independent Slopes Model (PRISM):
* Dataset: PRISM daily and monthly averaged variables from 1981-2020
* Variables: 2-meter temperature and total precipitation
* Download: Via the website https://prism.oregonstate.edu/recent/. 

2. ECMWF Reanalysis v5 - Land (ERA5-LAND):
* Dataset: ERA5-LAND daily and monthly averaged variables from 1981-2020
* Variables: 2-meter temperature and total precipitation
* Processing: Download hourly data and process to generate daily and monthly averages
* Download: Via the Copernicus Climate Change Service (C3S) API. 

3. Coupled Model Intercomparison Project v6 (CMIP6) Historical and SSP585(future) Data:
* Dataset: CMIP6 daily and monthly averaged model output from 1981-2014 and 2015-2100. See paper for list of models used in this analysis.
* Variables: 2-meter temperature and total precipitation
* Download: Via World Climate Research Programme (WCRP) https://esgf-node.llnl.gov/search/cmip6/




