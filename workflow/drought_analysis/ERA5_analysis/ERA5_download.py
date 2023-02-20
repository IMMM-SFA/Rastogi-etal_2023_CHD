import cdsapi
import os
import itertools

###### Define Main Download Function to be iterated ######
def era5_download(
    dataset = "reanalysis-era5-land-monthly-means",
    product_type = "monthly_averaged_reanalysis",
    variables = "2m_temperature",
    years = range(1979,2021),
    months = range(1,13),
    format = "netcdf",
    latmin = 0,
    latmax = 180,
    lonmin = -180,
    lonmax = 180,
    outname = 'download.nc'
):

    c = cdsapi.Client()
    c.retrieve(
        dataset,
        {
            "product_type": product_type,
            "variable": variables,
            "year": years,
            "month" : months,
	    "time": '00:00',	
            "format": format,
            "area": [latmax,lonmin,latmin,lonmax],
        }, 
        outname)



######### Define Dataset and Product Type ##########
era5_dataset = "reanalysis-era5-land-monthly-means"
era5_product_type = "monthly_averaged_reanalysis"


######### Define Time/Space Grid ###########
latmin = 22
latmax = 50
lonmin = -125
lonmax = -65

yrs = list(range(1981,2021))
mons = list(range(1,13))


######### Define Variables ###########
variables = ["total_precipitation", "2m_temperature"]
var_abbrev = ["tp", "2t"]


######### Run Iterating Download Function ###########
for i,curr_var in enumerate(variables):

    curr_var_abbrev = var_abbrev[i]
    os.chdir('/drought_analysis/input_data/ERA5/monthly/'+curr_var_abbrev) # Output file location

    era5_download(dataset = era5_dataset, product_type = era5_product_type, variables = curr_var, years = yrs, months = mons, latmin=latmin, latmax=latmax, lonmin=lonmin, lonmax=lonmax, outname='_'.join(['ERA5',curr_var_abbrev,'CONUS','monthly',str(min(yrs))+str(min(mons)).zfill(2)+'_'+str(max(yrs))+str(max(mons)).zfill(2)+'.nc']))



