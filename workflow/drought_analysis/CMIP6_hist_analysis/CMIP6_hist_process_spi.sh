#!/bin/bash

export PATH=$PATH:... ## add path to python environment containing climate_indices module
export HDF5_USE_FILE_LOCKING=FALSE

FILES=... ## absolute path to 1degree CMIP6 historical precipitation file

cd ... ## absolute path to desired output folder

for f in $FILES ; do
   
   f_path="${f%.nc}"
   echo $f
    
   prefix="..."         ## insert absolute path to input CMIP6 file
   outbase=${f_path#"$prefix"}
   outbase="${outbase}"

   process_climate_indices --index spi --periodicity monthly --netcdf_precip $f --var_name_precip pr --output_file_base $outbase --scales 6 --calibration_start_year 1981 --calibration_end_year 2014 --multiprocessing all 

   echo $outbase
done


