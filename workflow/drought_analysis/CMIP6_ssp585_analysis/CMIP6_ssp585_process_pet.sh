#!/bin/bash

export PATH=$PATH:... ## add path to python environment containing climate_indices module
export HDF5_USE_FILE_LOCKING=FALSE

FILES=... ## absolute path to 1degree CMIP6 ssp585 temperature file

cd ... ## absolute path to desired output folder

for f in $FILES ; do

   f_path="${f%.nc}"
   prefix="..." ## absolute path to input CMIP6 file
   outbase=${f_path#"$prefix"} ## remove path and keep only filename
   outbase="${outbase}" ## output file will be saved as [outbase]_pet_thornthwaite.nc

   echo $outbase
   
   process_climate_indices --index pet --periodicity monthly --netcdf_temp $f --var_name_temp tas --output_file_base $outbase --multiprocessing all

done



