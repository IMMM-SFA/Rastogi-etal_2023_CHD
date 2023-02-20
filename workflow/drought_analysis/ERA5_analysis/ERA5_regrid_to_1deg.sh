#!/bin/bash

export PATH=$PATH... ## add paths to folder containing gridfile.txt and  python environment containing nco module
export HDF5_USE_FILE_LOCKING=FALSE

##### ERA5 precipitation #####
f=... ## ERA5 precip file
f_temp=... ## temporary file name in same directory as f
f_1deg=... ## 1degree ERA5 precip file

ncks --no_abc -O --fl_fmt=netcdf4_classic $f $f_temp # convert 64-bit offset format to netCDF4_classic
ncrename -O -d .latitude,lat -v .latitude,lat -d .longitude,lon -v .longitude,lon $f_temp
cdo remapbil,gridfile.txt $f_temp $f_1deg
rm $f_temp


##### ERA5 2m temperature #####
f=... ## ERA5 temperature file
f_temp=... ## temporary file name in same directory as f
f_1deg=... ## 1degree ERA5 temperature file

ncks --no_abc -O --fl_fmt=netcdf4_classic $f $f_temp # convert 64-bit offset format to netCDF4_classic
ncrename -O -d .latitude,lat -v .latitude,lat -d .longitude,lon -v .longitude,lon $f_temp
cdo remapbil,gridfile.txt $f_temp $f_1deg
rm $f_temp

