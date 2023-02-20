#!/bin/bash

# Note: This script requires the edited climate indices scripts contained in the folder updated_climate_indices/

export PATH=$PATH:... ## add path to python environment containing the climate_indices module with updated scripts
export HDF5_USE_FILE_LOCKING=FALSE

FILES=... ## absolute path to 1degree CMIP6 ssp585 precipitation file

cd ... ## absolute path to desired output folder

for f in $FILES ; do
   
   # process SPI
   f_path="${f%.nc}"
   prefix="..."        ## insert absolute path to input CMIP6 ssp585 precipitation file
   outbase=${f_path#"$prefix"}
   outbase="${outbase}"

   model="$(grep -oP '(?<=pr_Amon_).*?(?=_ssp585)' <<< "$f")"
   echo $model
   
   ## assign f_params to the CMIP6 historical pr file corresponding to the current f_pr file
   f_params=("...[ insert path to ssp585 pet files ].../pr_Amon_${model}_historical"_*.nc)
   echo "${f_params[0]}"

   process_climate_indices --index spi --periodicity monthly --netcdf_precip $f --var_name_precip pr --output_file_base $outbase --scales 6 --calibration_start_year 1981 --calibration_end_year 2014 --multiprocessing all --netcdf_params_precip "${f_params[0]}"

   echo $outbase
done


