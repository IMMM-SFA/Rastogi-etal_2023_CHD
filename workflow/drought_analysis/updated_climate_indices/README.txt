This is an edited version of the python climate_indices module which can be downloaded (in its original form) at
https://climate-indices.readthedocs.io/en/latest/#download-the-code (Adams 2017)

This updated module provides additional functionality for the "process_climate_indices" function:
	- The climate indices will be computed using the standard input data calculated using specified calibration files.

	- Calibration files must be specified via additional input arguments:

		--netcdf_params_precip foo.nc   # when --index is spei or spi
			--> Where foo.nc contains the historical CMIP6 precipitation data under variable name "pr". 
			--> This precipitation data will be used for calibration (i.e. gamma distributions will be fit to this calibration dataset).

		--netcdf_params_pet foo.nc   # when --index is spei
			--> where foo.nc contains the historical CMIP6 potential evapotranspiration data under variable name "pet_thornthwaite"
			--> This potential evapotranspiration data will be used for calibration (i.e. gamma distributions will be fit to this calibration dataset).

	- Output files will all be computed with gamma distributions (Pearson Type III files will not be produced)

** In order for the following scripts to run, the scripts located in climate_indices/ must be replaced with
edited versions located in directory updated_climate_indices/

Scripts which require this updated module:
	CMIP6_ssp585_process_spi.sh
	CMIP6_ssp585_process_spei.sh

