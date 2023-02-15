load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
dir        = "./data"
drght_ints = "extreme_drought"

;spi/spei
drght_indx = "spei"
drght_dur  = "06"
hw_thresh  = "t95"
hw_length_thresh = "3days"
period     = "historical"

fmask      = addfile("fmask.nc","r")
mask1      = fmask->tmax(0,:,:) 
year       = ispan(1981,2014,1)
dataname1  = "ERA5"

;Read lat lon
fll        = addfile("latlon.nc","r")
lat        = fll->lat
lon        = fll->lon
nlat       = dimsizes(lat)
nlon       = dimsizes(lon)
mm1        = (/0,30,61/)
mm2        = (/29,60,91/)

gcm        = asciiread(dir+"gcm.txt",-1,"string")

;Read heatwave and drought in GCMs
do gg      = 0,dimsizes(gcm)-1
print(gcm(gg))

dirdrght     = "/global/cfs/cdirs/m2702/im3-climtask/jttrok/drought_metrics/CMIP6_hist/"+drght_indx+"/"
dirdrght_ind = "/global/cfs/cdirs/m2702/im3-climtask/jttrok/drought_indices/CMIP6_hist/"+drght_indx+"/finished/"


fdrght       = addfile(dirdrght+gcm(gg)+"_198001-201412_1deg_"+drght_indx+"_gamma_"+drght_dur+"_drought_metrics.nc","r")
fdrght_ind   = addfile(dirdrght_ind+gcm(gg)+"_198001-201412_1deg_"+drght_indx+"_gamma_"+drght_dur+".nc","r")



drght        = fdrght->$drght_ints$(0:419,:,:)
var_drght    = drght_indx+"_gamma_"+drght_dur
drght_ind1   = fdrght_ind->$var_drght$(:,:,0:419)
drght_ind1@_FillValue = -999.
replace_ieeenan (drght_ind1, drght_ind1@_FillValue, 0)

drght_ind    = drght_ind1(time|:,lat|:,lon|:)
drght_yr     = new((/dimsizes(year),12,nlat,nlon/),"double")
drght_yrind  = new((/dimsizes(year),12,nlat,nlon/),"double")

ext_days       = new((/dimsizes(year),7,180,360/),"float")
tmax_ext_days  = new((/dimsizes(year),7,180,360/),"float")
drght_ext_days = new((/dimsizes(year),7,180,360/),"float")

do yy = 0,dimsizes(year)-1
print(year(yy))

stt = yy*12 +12; if starting in 1981
stpp = stt+11
drght_yr(yy,:,:,:)    = drght(stt:stpp,:,:)
drght_yrind(yy,:,:,:) = drght_ind(stt:stpp,:,:)

end do

countyy = new((/dimsizes(year),92,7/),"float")

do yy = 0, dimsizes(year)-1

dailyDrght0    = new((/92,dimsizes(lat),dimsizes(lon)/),"double")
dailyDrght0ind = new((/92,dimsizes(lat),dimsizes(lon)/),"double")

do mm = 0,2

drght_yrC = conform(dailyDrght0(mm1(mm):mm2(mm),:,:),drght_yr(yy,mm+5,:,:),(/1,2/))
dailyDrght0(mm1(mm):mm2(mm),:,:) = drght_yrC

drght_yrCind = conform(dailyDrght0ind(mm1(mm):mm2(mm),:,:),drght_yrind(yy,mm+5,:,:),(/1,2/))
dailyDrght0ind(mm1(mm):mm2(mm),:,:) = drght_yrCind


delete(drght_yrC)
delete(drght_yrCind)

end do

fhw  = addfile(dir+"./netcdf/hw_min"+hw_length_thresh+"_above"+hw_thresh+"_JJA_"+year(yy)+"-"+gcm(gg)+".nc","r")
tmax = fhw->tmax(:,:,:)
time = fhw->time

strtflx = 151
stppflx = strtflx+91

hw            = fhw->hw_present(:,:,:)
hw_index      = fhw->index
dailyDrght    = dailyDrght0
dailyDrghtind = dailyDrght0ind
stb           = hw
mask1c1       = conform(stb,mask1,(/1,2/))
mask1c        = floattointeger(mask1c1)
stb           = where(ismissing(mask1c),mask1c@_FillValue,stb)
dailyDrght          = where(ismissing(mask1c),mask1c@_FillValue,dailyDrght)
dailyDrghtind       = where(ismissing(mask1c),mask1c@_FillValue,dailyDrghtind)

;Check grid points with extremes
count0 = where(stb.eq.0.and.dailyDrght.eq.0,1,0)
count1 = where(stb.gt.0,1,0)
count2 = where(dailyDrght.gt.0,1,0)
count3 = where(stb.gt.0.and.dailyDrght.gt.0,1,0)
count4 = where(stb.gt.0.and.dailyDrght.eq.0,1,0)
count5 = where(stb.eq.0.and.dailyDrght.gt.0,1,0)

ext_days(yy,0,:,:) = dim_sum_n_Wrap(count0,0)
ext_days(yy,1,:,:) = dim_sum_n_Wrap(count1,0)
ext_days(yy,2,:,:) = dim_sum_n_Wrap(count2,0)
ext_days(yy,3,:,:) = dim_sum_n_Wrap(count3,0)
ext_days(yy,4,:,:) = dim_sum_n_Wrap(count4,0)
ext_days(yy,5,:,:) = dim_sum_n_Wrap(count5,0)

drght0 = where(count0.eq.1,dailyDrghtind,dailyDrghtind@_FillValue)
drght1 = where(count1.eq.1,dailyDrghtind,dailyDrghtind@_FillValue)
drght2 = where(count2.eq.1,dailyDrghtind,dailyDrghtind@_FillValue)
drght3 = where(count3.eq.1,dailyDrghtind,dailyDrghtind@_FillValue)
drght4 = where(count4.eq.1,dailyDrghtind,dailyDrghtind@_FillValue)
drght5 = where(count5.eq.1,dailyDrghtind,dailyDrghtind@_FillValue)
drght_ext_days(yy,0,:,:) = doubletofloat(dim_avg_n_Wrap(drght0,0))
drght_ext_days(yy,1,:,:) = doubletofloat(dim_avg_n_Wrap(drght1,0))
drght_ext_days(yy,2,:,:) = doubletofloat(dim_avg_n_Wrap(drght2,0))
drght_ext_days(yy,3,:,:) = doubletofloat(dim_avg_n_Wrap(drght3,0))
drght_ext_days(yy,4,:,:) = doubletofloat(dim_avg_n_Wrap(drght4,0))
drght_ext_days(yy,5,:,:) = doubletofloat(dim_avg_n_Wrap(drght5,0))

tmax0 = where(count0.eq.1,tmax,tmax@_FillValue)
tmax1 = where(count1.eq.1,tmax,tmax@_FillValue)
tmax2 = where(count2.eq.1,tmax,tmax@_FillValue)
tmax3 = where(count3.eq.1,tmax,tmax@_FillValue)
tmax4 = where(count4.eq.1,tmax,tmax@_FillValue)
tmax5 = where(count5.eq.1,tmax,tmax@_FillValue)

tmax_ext_days(yy,0,:,:) = dim_avg_n_Wrap(tmax0,0)
tmax_ext_days(yy,1,:,:) = dim_avg_n_Wrap(tmax1,0)
tmax_ext_days(yy,2,:,:) = dim_avg_n_Wrap(tmax2,0)
tmax_ext_days(yy,3,:,:) = dim_avg_n_Wrap(tmax3,0)
tmax_ext_days(yy,4,:,:) = dim_avg_n_Wrap(tmax4,0)
tmax_ext_days(yy,5,:,:) = dim_avg_n_Wrap(tmax5,0)



end do
ext_days!0 = "year"
ext_days!1 = "ext"
ext_days!2 = "lat"
ext_days!3 = "lon"
ext_days&lat = lat
ext_days&lon = lon

copy_VarCoords(ext_days,drght_ext_days)
copy_VarCoords(ext_days,tmax_ext_days)

fileout = "ext_days_tmax_"+hw_thresh+"_"+hw_length_thresh+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+".1deg.nc"
system("rm "+fileout)
fout = addfile(fileout,"r")
fout->ext_days      = ext_days
fout->drght_ext_days= drght_ext_days
fout->tmax_ext_days = tmax_ext_days
end do
end
