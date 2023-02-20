#!/bin/bash

export PATH=$PATH:... ## add path to python environment containing climate_indices module
export HDF5_USE_FILE_LOCKING=FALSE

FILES_pr=... ## absolute path to 1degree CMIP6 historical precipitation file

cd ... ## absolute path to desired output folder

for f_pr in $FILES_pr ; do

    f_path="${f_pr%.nc}"	
    prefix="..." 	## insert absolute path to input CMIP6 file
    outbase=${f_path#"$prefix"} 
    outbase="${outbase}" 	## output file will be saved as [outbase]_spei_gamma_##.nc
    
    model="$(grep -oP '(?<=pr_Amon_).*?(?=_historical)' <<< "$f_pr")" ## obtain model name from full filename
    echo $model

    ## assign F_pet to the correct PET file corresponding to the current f_pr file
    F_pet=("...[ insert path to pet files ]..../tas_Amon_${model}_historical"_*.nc)  
    f_pet="${F_pet[0]}"

    echo $f_pr
    echo $f_pet

    if [[ ! -f $f_pr ]] || [[ ! -f $f_pet ]] ; then
        echo 'not all files exist'
    else
    	process_climate_indices --index spei --periodicity monthly --netcdf_precip $f_pr --var_name_precip pr --netcdf_pet $f_pet --var_name_pet pet_thornthwaite --output_file_base $outbase --scales 6 --calibration_start_year 1981 --calibration_end_year 2014 --multiprocessing all 
    fi

    echo $outbase
done

