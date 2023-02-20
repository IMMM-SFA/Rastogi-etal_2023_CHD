#!/bin/bash

export PATH=$PATH... ## add path to python environment containing climate_indices module
export HDF5_USE_FILE_LOCKING=FALSE

f_2t_1deg=... ## absolute path to 1degree PRISM temperature file

outbase=PRISM_CONUS_1deg_monthly_198101_202012 ## output file will be saved as [outbase]_pet_thornthwaite.nc

cd ... ## absolute path to desired output folder

process_climate_indices --index pet --periodicity monthly --netcdf_temp $f_2t_1deg --var_name_temp t2m --output_file_base $outbase --multiprocessing all

