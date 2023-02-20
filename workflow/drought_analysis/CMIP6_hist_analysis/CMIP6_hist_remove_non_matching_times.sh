#!/bin/bash

# 
# The CMIP6_hist_process_spei.sh script will not work for all files if the precip and temperature files contain "non-matching times". 
# This script removes uneccesary months of data to ensure time variables match for each CMIP6 model's pr and tas file.
#

export PATH=$PATH:...  ## add path to python environment containing nco module

## CESM2 pr file has 1 additional month of data ##
## remove 1 month of data ##
FILES=..[insert path to pr files used for spei]../CMIP6_hist/1deg/pr/spei_files/pr_Amon_CESM2* 

for f in $FILES ; do
    f_new="${f%.nc}"
    f_new="${f_new}_adjusted.nc"
    echo $f_new
    ncks -F -d time,2,420,1 -v pr $f $f_new
done


## MCM-UA-1-0 pr file has 1 additional month of data ##
## remove 1 month of data ##
FILES=..[insert path to pr files used for spei]../CMIP6_hist/1deg/pr/spei_files/pr_Amon_MCM-UA-1-0* 

for f in $FILES ; do
	f_new="${f%.nc}"
        f_new="${f_new}_adjusted.nc"
	echo $f_new
	ncks -F -d time,1,419,1 -v pr $f $f_new
done


## remove final 2 years of data from FGOALS-g3 pr file ##
## save with ...198001-201412_1deg_adjusted.nc ##
FILES=..[insert path to pr files used for spei]../CMIP6_hist/1deg/pr/spei_files/pr_Amon_FGOALS-g3_historical_r1i1p1f1_gn_198001-201612_1deg.nc 

for f in $FILES ; do
	f_new=..[insert path to pr files used for spei]..CMIP6_hist/1deg/pr/spei_files/pr_Amon_FGOALS-g3_historical_r1i1p1f1_gn_198001-201412_1deg_adjusted.nc
	echo $f_new
	ncks -F -d time,1,420,1 -v pr $f $f_new
done


