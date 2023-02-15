load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
drght_ints       = "extreme_drought"
;Run for spi/spei
drght_indx       = "spi"
drght_dur        = "06"
hw_thresh        = "t95"
hw_length        = "3days"
period           = "historical"

;Run for historical and future years
year             = ispan(1981,2014,1)

;Read lat lon
fll              = addfile("latlon.nc","r")
lat              = fll->lat
lon              = fll->lon
nlat             = dimsizes(lat)
nlon             = dimsizes(lon)
mm1              = (/0,30,61/)
mm2              = (/29,60,91/)

gcm              = asciiread("gcm.txt",-1,"string")
do gg            = 0,dimsizes(gcm)-1

dirdrght         = "./data/"
dirdrght_ind     = "./data/"
fdrght           = addfile(dirdrght+gcm(gg)+"_198001-201412_1deg_"+drght_indx+"_gamma_"+drght_dur+"_drought_metrics.nc","r")
fdrght_ind       = addfile(dirdrght_ind+gcm(gg)+"_198001-201412_1deg_"+drght_indx+"_gamma_"+drght_dur+".nc","r")

drght            = fdrght->$drght_ints$(0:419,:,:)
var_drght        = drght_indx+"_gamma_"+drght_dur
drght_ind1       = fdrght_ind->$var_drght$(:,:,0:419)
drght_ind1@_FillValue = -999.
replace_ieeenan (drght_ind1, drght_ind1@_FillValue, 0)

drght_ind        = drght_ind1(time|:,lat|:,lon|:)
drght_yr         = new((/dimsizes(year),12,nlat,nlon/),"double")
drght_yrind      = new((/dimsizes(year),12,nlat,nlon/),"double")
do yy            = 0,dimsizes(year)-1
stt              = yy*12 +12; if starting in 1981
stpp             = stt+11
drght_yr(yy,:,:,:)    = drght(stt:stpp,:,:)
drght_yrind(yy,:,:,:) = drght_ind(stt:stpp,:,:)
end do


count3           = new((/dimsizes(year),92,dimsizes(lat),dimsizes(lon)/),"float")
slhf3            = new((/dimsizes(year),92,dimsizes(lat),dimsizes(lon)/),"float")
sshf3            = new((/dimsizes(year),92,dimsizes(lat),dimsizes(lon)/),"float")
tmax3            = new((/dimsizes(year),92,dimsizes(lat),dimsizes(lon)/),"float")

;Create new variables to store annual averages
do yy            = 0, dimsizes(year)-1

dailyDrght0      = new((/92,dimsizes(lat),dimsizes(lon)/),"double")
dailyDrght0ind   = new((/92,dimsizes(lat),dimsizes(lon)/),"double")
do mm            = 0,2
drght_yrC        = conform(dailyDrght0(mm1(mm):mm2(mm),:,:),drght_yr(yy,mm+5,:,:),(/1,2/))
dailyDrght0(mm1(mm):mm2(mm),:,:) = drght_yrC

drght_yrCind     = conform(dailyDrght0ind(mm1(mm):mm2(mm),:,:),drght_yrind(yy,mm+5,:,:),(/1,2/))
dailyDrght0ind(mm1(mm):mm2(mm),:,:) = drght_yrCind
delete(drght_yrC)
delete(drght_yrCind)
end do
fhw              = addfile("./netcdf/hw_min"+hw_length+"_above"+hw_thresh+"_JJA_"+year(yy)+"-"+gcm(gg)+".nc","r")
daytmax          = fhw->tmax(:,:,:)
time             = fhw->time
strtflx          = 151
stppflx          = strtflx+91

fslhf            = addfile(dir+"/hfls_day_"+gcm(gg)+"_historical_"+ens+"_"+gn+"_"+year(yy)+"-JJA_1deg.nc","r")
fsshf            = addfile(dir+"/hfss_day_"+gcm(gg)+"_historical_"+ens+"_"+gn+"_"+year(yy)+"-JJA_1deg.nc","r")
slhf             = fslhf->hfls
sshf             = fsshf->hfss
hw               = fhw->hw_present(:,:,:)
dailyDrght       = doubletofloat(dailyDrght0)
dailyDrghtind    = doubletofloat(dailyDrght0ind)
mask1c1          = conform(stb,mask1,(/1,2/))
mask1c           = floattointeger(mask1c1)
hw               = where(ismissing(mask1c),mask1c@_FillValue,hw)
dailyDrght       = where(ismissing(mask1c),mask1c@_FillValue,dailyDrght)
dailyDrghtind    = where(ismissing(mask1c),mask1c@_FillValue,dailyDrghtind)
count3(yy,:,:,:) = where(hw.gt.0.and.dailyDrght.gt.0,1,0)
slhf3(yy,:,:,:)  = where(count3(yy,:,:,:).eq.1,slhf,slhf@_FillValue)
sshf3(yy,:,:,:)  = where(count3(yy,:,:,:).eq.1,sshf,sshf@_FillValue)
tmax3(yy,:,:,:)  = where(count3(yy,:,:,:).eq.1,tmax,tmax@_FillValue)
end do

count3!0         = "year"
count3!1         = "days"
count3!2         = "lat"
count3!3         = "lon"
count3&lat       = lat
count3&lon       = lon
copy_VarCoords(count3,slhf3)
copy_VarCoords(count3,sshf3)

lat1 = 24
lat2 = 53
lon1 = 235
lon2 = 295

fileout          = "hw_intensities_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+gcm(gg)+".1deg.nc"
system("rm "+fileout)
fout1            = addfile(fileout,"c")
fout1->concur    = tmax3(:,:,{lat1:lat2},{lon1:lon2})

fileout1         = "slhf_intensities_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+".1deg.nc"
system("rm "+fileout1)
fout1            = addfile(fileout1,"c")
fout1->concur    = slhf3(:,:,{lat1:lat2},{lon1:lon2})

fileout2         = "sshf_intensities_"+hw_thresh+"_"+hw_length+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+".1deg.nc"
system("rm "+fileout2)
fout2            = addfile(fileout2,"c")
fout2->concur    = sshf3(:,:,{lat1:lat2},{lon1:lon2})

end do
end
