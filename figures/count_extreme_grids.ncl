load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
;This script counts grid points with extremes and write it out in a netcdf file
drght_ints = "extreme_drought"
drght_indx = "spei"
drght_dur  = "06"
hw_thresh  = "t95"
hw_length  = "3days"
period     = "historical"

fmask      = addfile("fmask.nc","r")
mask1      = fmask->tmax(0,:,:) 

;Run for historical and future periods
year       = ispan(1981,2014,1)
dts        = "06"

;Read lat lon
fll        = addfile("latlon.nc","r")
lat        = fll->lat
lon        = fll->lon
nlat       = dimsizes(lat)
nlon       = dimsizes(lon)
mm1        = (/0,30,61/)
mm2        = (/29,60,91/)

gcm        = asciiread("gcm.txt",-1,"string")

;Read heatwave and drought identified in GCMs
do gg      = 0,dimsizes(gcm)-1

;Create new variables to store annual averages
dirdrght   = "./data/'
fdrght     = addfile(dirdrght+gcm(gg)+"_198001-201412_1deg_"+drght_indx+"_gamma_"+drght_dur+"_drought_metrics.nc","r")


drght      = fdrght->$drght_ints$(0:419,:,:)
drght_yr   = new((/dimsizes(year),12,nlat,nlon/),"double")

do yy      = 0,dimsizes(year)-1

stt        = yy*12 +12; if starting in 1981
stpp       = stt+11
drght_yr(yy,:,:,:) = drght(stt:stpp,:,:)

end do

countyy         = new((/dimsizes(year),92,7/),"float")

;Create new variables to store annual averages
do yy           = 0, dimsizes(year)-1
dailyDrght0     = new((/92,dimsizes(lat),dimsizes(lon)/),"double")

do mm           = 0,2

drght_yrC       = conform(dailyDrght0(mm1(mm):mm2(mm),:,:),drght_yr(yy,mm+5,:,:),(/1,2/))
dailyDrght0(mm1(mm):mm2(mm),:,:) = drght_yrC
delete(drght_yrC)

end do

fhw             = addfile("./netcdf/hw_min"+hw_length+"_above"+hw_thresh+"_JJA_"+year(yy)+"-"+gcm(gg)+".nc","r")
tmax            = fhw->tmax(:,:,:)
time            = fhw->time



hw              = fhw->hw_present(:,:,:)
dailyDrght      = dailyDrght0
mask1c1         = conform(hw,mask1,(/1,2/))
mask1c          = floattointeger(mask1c1)
hw              = where(ismissing(mask1c),mask1c@_FillValue,hw)
dailyDrght      = where(ismissing(mask1c),mask1c@_FillValue,dailyDrght)

;Count grid points with heatwave, drought, heatwave+drought, heatwave only, drought only
count0          = where(hw.eq.0.and.dailyDrght.eq.0,1,0)
count1          = where(hw.gt.0,1,0)
count2          = where(dailyDrght.gt.0,1,0)
count3          = where(hw.gt.0.and.dailyDrght.gt.0,1,0)
count4          = where(hw.gt.0.and.dailyDrght.eq.0,1,0)
count5          = where(hw.eq.0.and.dailyDrght.gt.0,1,0)

countyy(yy,:,0) = dim_num_n(.not.ismissing(mask1c),(/1,2/)) 
countyy(yy,:,1) = dim_sum_n_Wrap(count0,(/1,2/))
countyy(yy,:,2) = dim_sum_n_Wrap(count1,(/1,2/))
countyy(yy,:,3) = dim_sum_n_Wrap(count2,(/1,2/))
countyy(yy,:,4) = dim_sum_n_Wrap(count3,(/1,2/))
countyy(yy,:,5) = dim_sum_n_Wrap(count4,(/1,2/))
countyy(yy,:,6) = dim_sum_n_Wrap(count5,(/1,2/))

delete([/tmax,count0,count1,count2,count3,count4,count5,dailyDrght,mask1c1,mask1c,dailyDrght0,time,hw/])
end do

countyy!0       = "year"
countyy!1       = "days"

;Write netcdf files with grid counts
fileout         = "count_HW_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+gcm(gg)+"_"+period+".nc"
system("rm "+fileout)
fout            = addfile(fileout)
fout->count     = countyy
delete(countyy)
end do
end
