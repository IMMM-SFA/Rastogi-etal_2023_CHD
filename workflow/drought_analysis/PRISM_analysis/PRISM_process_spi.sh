#!/bin/bash

export PATH=$PATH... ## add path to python environment containing climate_indices module
export HDF5_USE_FILE_LOCKING=FALSE

f_1deg=... ## absolute path to 1degree PRISM precipitation file

outbase=PRISM_CONUS_1deg_monthly_198101_202012 ## output file will be saved as [outbase]_spi_##

cd ... ## absolute path to desired output folder

process_climate_indices --index spi --periodicity monthly --netcdf_precip $f_1deg --var_name_precip tp --output_file_base $outbase --scales 6 --calibration_start_year 1981 --calibration_end_year 2014 --multiprocessing all

