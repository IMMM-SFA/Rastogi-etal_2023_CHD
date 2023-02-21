load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;********************************************
begin
year          = ispan(1981,2014,1)
dir           = "./data/"
gcm           = asciiread("gcm.txt",-1,"string")
do gg         = 0,dimsizes(gcm)-1

ft95          = addfile("./netcdf/"+gcm(gg)+"_t95_"+year(0)+"-"+year(dimsizes(year)-1)+"_JJA.nc","r")
t95           = ft95->t95

f1            = addfile(dir+"tasmax_day_"+gcm(gg)+"_historical_"+year(0)+"-JJA_1deg.nc","r")
tmax          = f1->tasmax
t95C          = conform(tmax,t95,(/1,2/))
 
do yy         = 0,dimsizes(year)-1
f1            = addfile(dir+"tasmax_day_"+gcm(gg)+"_historical_"+year(yy)+"-JJA_1deg.nc","r")
lat           = f1->lat
lon           = f1->lon
nlat          = dimsizes(lat)
nlon          = dimsizes(lon)
daytmax       = f1->tasmax
daytmax       = daytmax-273.15
time          = f1->time
num_t95       = where(daytmax.gt.t95C,1,0)
num_t95!0     = "time"
num_t95!1     = "lat"
num_t95!2     = "lon"
num_t95&time  = time
num_t95&lat   = lat
num_t95&lon   = lon
copy_VarCoords(num_t95,daytmax)
;Write files

fileout       = "./netcdf/numdays_abovet95_daily_"+year(yy)+"_"+gcm(gg)+".nc"
system("rm "+fileout)
fout          = addfile(fileout,"c")
fout->num_t95 = num_t95
fout->tmax    = daytmax
delete([/daytmax,num_t95,time/])

end do
delete([/t95,t95C/])
end do
end



