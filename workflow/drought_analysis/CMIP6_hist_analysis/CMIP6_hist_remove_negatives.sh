#!/bin/bash

export PATH=$PATH: ## add path to python environment containing nco module
export HDF5_USE_FILE_LOCKING=FALSE
#export NCO_MMR_DBG=1

########  precipitation  ########

FILES=...CMIP6_hist/1deg/pr/pr_Amon*.nc ## absolute path to CMIP6 historical pr files (use wildcard * to get all files)
for f in $FILES ; do
    ncap2 -s "where('pr'<0) 'pr'=0;" $f -O $f
    #cp $f <location of pr files used in spei calculation if desired> 
done



