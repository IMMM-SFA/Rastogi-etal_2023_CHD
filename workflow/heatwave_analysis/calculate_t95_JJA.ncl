load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;********************************************
begin
;This script calculates 95th percentile of daily maximum temperature
year = ispan(1981,2014,1)
dir = "./data/"
gcm  = asciiread("gcm.txt",-1,"string")
print(gcm)
do gg = 0,dimsizes(gcm)-1

ens = "r1i1p1f1"
gn  = "gn"

f1 = addfiles(dir+"tasmax_day_"+gcm(gg)+"_historical_"+year+"-JJA_1deg.nc","r")

lat  = f1[0]->lat
lon  = f1[0]->lon
nlat = dimsizes(lat)
nlon = dimsizes(lon)
rf_p95y = new((/nlat,nlon/),"float")
tmax = f1[:]->tasmax(:,:,:)
tmax = tmax-273.15
dims = dimsizes(tmax)
dimt = dims(0)
do lt = 0,nlat-1
do ln = 0,nlon-1

        rf_ltln = tmax(:,lt,ln)
        qsort(rf_ltln)
        rf_sort = rf_ltln
        rf_sort@_FillValue = -999
        rf_rain = rf_sort
        rf_notm = num(.not.ismissing(rf_rain))
        rf_notm@_FillValue = -999
        rf_notm = where(rf_notm.eq.0.,rf_notm@_FillValue,rf_notm)

if (.not.ismissing(rf_notm)) then

        rf_rnst = rf_rain(dimt-rf_notm:dimt-1)
        dimt0 = dimsizes(rf_rnst)
        dimtn = dimt0(0)
        rf_5prc = round(0.05*rf_notm,3)
        rf_rnst@_FillValue = -999
        if (rf_5prc.gt.0) then
                rf_thrsh5 = rf_rnst(dimtn-rf_5prc)
        else
                rf_thrsh5 = rf_rnst@_FillValue
        end if
	delete(rf_rnst)
        rf_p95y(lt,ln)  = rf_thrsh5
end if
end do ; ln
end do ; lt

delete(tmax)
delete(rf_ltln)
delete(rf_sort)
delete(rf_rain)

rf_p95y!0 = "lat"
rf_p95y!1 = "lon"
rf_p95y&lat = lat
rf_p95y&lon = lon

system("rm ./netcdf/"+gcm(gg)+"_t95_"+year(0)+"-"+year(dimsizes(year)-1)+"_JJA.nc")
fout = addfile("./netcdf/"+gcm(gg)+"_t95_"+year(0)+"-"+year(dimsizes(year)-1)+"_JJA.nc","c")
fout->t95=rf_p95y
end do
end



