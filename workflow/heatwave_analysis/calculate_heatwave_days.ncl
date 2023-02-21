load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
external TEST "./heatwave.so"
;This scripts identifies the heatwave days using 95th percentile tmax threshold
percentile = "95"
var     = "num_t"+percentile
length  = 3
year    = ispan(1981,2014,1)
dir     = "../data/"
gcm     = asciiread("gcm.txt",-1,"string")
print(gcm)
do gg   = 0,dimsizes(gcm)-1

do yy   = 0,dimsizes(year)-1

f1      = addfile("./netcdf/numdays_abovet"+percentile+"_daily_"+year(yy)+"_"+gcm(gg)+".nc","r")
numdays = f1->$var$
tmax    = f1->tmax
lat     = f1->lat
lon     = f1->lon
dims    = dimsizes(numdays)

delete(numdays@_FillValue)
delete(numdays@missing_value)
numdays@_FillValue    = -999
numdays@missing_value = -999
numdays = where(numdays.eq.-32767,numdays@_FillValue,numdays)

;minimum number of consecutive days for heatwave definition
min_hw_start = length

;maximum allowable break days, setting zero 
max_break        = 0

;Minimum subsequent days for heatwave to continue after the break, this is zero if max_break is zero
min_subsequent    = 0

hw_days_count     = new((/dims(0),dims(1),dims(2)/),"float")
;This will store the length of heatwave at the first timestep of the heatwave or the time where heatwave start
hw_days_count     = 0

;Not applicable if max_break=0, So just setting to 0
sub_hw_days_count = numdays
sub_hw_days_count = 0
break_days_count  = numdays
break_days_count  = 0

hw_ix_all         = new((/dims(0),dims(1),dims(2)/),"float")
; This will store a unique count for heatwaves at each grid and season, e.g. it will have a value 1 for each day of the first heatwave, 2 for second heatwave
hw_ix_all         = 0

dims              = dimsizes(numdays)
nday              = dims(0)
nlat              = dims(1)
nlon              = dims(2)


print("calc hw")
TEST::main(numdays,nday,nlat,nlon,min_hw_start,max_break,min_subsequent,hw_days_count,sub_hw_days_count,break_days_count,hw_ix_all)
print("done calc")


hw_days_count!0   = "time"
hw_days_count!1   = "lat"
hw_days_count!2   = "lon"
hw_days_count&lat = lat
hw_days_count&lon = lon
copy_VarCoords(hw_days_count,sub_hw_days_count)
copy_VarCoords(hw_days_count,break_days_count)
copy_VarCoords(hw_days_count,hw_ix_all)

;binary variable for stitich blob
hw_present        = hw_ix_all
hw_present        = where(hw_ix_all.gt.0,1,0)

fileout           = "./netcdf/hw_min"+length+"days_abovet"+percentile+"_JJA_"+year(yy)+"-"+gcm(gg)+".nc"
system("rm "+fileout)
fout              = addfile(fileout,"c")
fout->hw_present  = hw_present
fout->index       = hw_ix_all
fout->tmax        = tmax
delete([/numdays1,numdays,hw_days_count,tmax,hw_present,hw_ix_all,sub_hw_days_count,break_days_count/])

end do
end do
end
