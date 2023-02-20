#!/bin/bash

# Note: This script requires the edited climate indices scripts contained in the folder updated_climate_indices/

export PATH=$PATH:... ## add path to python environment containing the climate_indices module with updated scripts
export HDF5_USE_FILE_LOCKING=FALSE

FILES_pr=... ## absolute path to 1degree CMIP6 ssp585 precipitation file

cd ... ## absolute path to desired output folder

for f_pr in $FILES ; do

    f_path="${f_pr%.nc}"	
    prefix="..."        ## insert absolute path to input CMIP6 ssp585 precipitation file
    outbase=${f_path#"$prefix"}
    outbase="${outbase}"
    
    model="$(grep -oP '(?<=pr_Amon_).*?(?=_ssp585)' <<< "$f_pr")" 
    echo $model

    ## assign F_pet to the correct PET file corresponding to the current f_pr file
    F_pet=("...[ insert path to ssp585 pet files ]..../tas_Amon_${model}_ssp585"_*.nc)
    f_pet="${F_pet[0]}"

    echo $f_pr
    echo $f_pet

    ## assign historical files to be used to compute calibration parameters
    F_params_pr=("...[ insert path to historical pr files ]..../pr_Amon_${model}_historical"_*.nc)
    f_params_pr="${F_params_pr[0]}"

    F_params_pet=("...[ insert path to historical pet files ]..../tas_Amon_${model}_historical"_*.nc)
    f_params_pet="${F_params_pet[0]}"

    echo $f_params_pr
    echo $f_params_pet

    ## ensure all four files exist
    if [[ ! -f $f_pr ]] || [[ ! -f $f_pet ]] || [[ ! -f $f_params_pr ]] || [[ ! -f $f_params_pet ]]; then
	echo 'not all files exist'
    else
    	process_climate_indices --index spei --periodicity monthly --netcdf_precip $f_pr --var_name_precip pr --netcdf_pet $f_pet --var_name_pet pet_thornthwaite --output_file_base $outbase --scales 6 --calibration_start_year 1981 --calibration_end_year 2014 --multiprocessing all --netcdf_params_precip $f_params_pr --netcdf_params_pet $f_params_pet
    fi

    echo $outbase
done

