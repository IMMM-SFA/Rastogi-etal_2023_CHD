load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
dir               = "./data/"
drght_ints        = "extreme_drought"
drght_indx        = "spei"
drght_dur         = "06"
hw_thresh         = "t95"
hw_length_thresh  = "3days"
dataname1         = "ERA5"
fmask             = addfile("fmask.nc","r")
mask1             = fmask->tmax(0,:,:)
year              = ispan(1981,2014,1)
gcm               = asciiread(dir+"gcm.txt",-1,"string")
print(gcm)
perhw_concur_gg   = new((/dimsizes(gcm),180,360/),"float")
perdr_concur_gg   = new((/dimsizes(gcm),180,360/),"float")
hw_gg             = new((/dimsizes(gcm),180,360/),"float")
dr_gg             = new((/dimsizes(gcm),180,360/),"float")
hd_gg             = new((/dimsizes(gcm),180,360/),"float")
tmax_hd_gg        = new((/dimsizes(gcm),180,360/),"float")
drght_hd_gg       = new((/dimsizes(gcm),180,360/),"float")
do gg             = 0,dimsizes(gcm)-1
print(gcm(gg))
dataname1         = gcm(gg)
dirt              = "./data/"
;Read lat lon
fll               = addfile("latlon.nc","r")

lat               = fll->lat
lon               = fll->lon
nlat              = dimsizes(lat)
nlon              = dimsizes(lon)
f1                = addfile(dir+"ext_days_tmax_"+hw_thresh+"_"+hw_length_thresh+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+".1deg.nc","r")
ext_days          = f1->ext_days
tmax_ext_days     = f1->tmax_ext_days
drght_ext_days    = f1->drght_ext_days

hw_gg(gg,:,:)     = dim_avg_n_Wrap(ext_days(:,1,:,:),0)
dr_gg(gg,:,:)     = dim_avg_n_Wrap(ext_days(:,2,:,:),0)
hd_gg(gg,:,:)     = dim_avg_n_Wrap(ext_days(:,3,:,:),0)
tmax_hd_gg(gg,:,:)= dim_avg_n_Wrap(tmax_ext_days(:,3,:,:),0)
drght_hd_gg(gg,:,:)= dim_avg_n_Wrap(drght_ext_days(:,3,:,:),0)

delete([/ext_days,tmax_ext_days,drght_ext_days/])

end do 

mask1C       = conform(hw_gg,mask1,(/1,2/))
tmax_hd_gg   = where(ismissing(mask1C),tmax_hd_gg@_FillValue,tmax_hd_gg)
drght_hd_gg  = where(ismissing(mask1C),drght_hd_gg@_FillValue,drght_hd_gg)
hw_gg        = where(ismissing(mask1C),hw_gg@_FillValue,hw_gg)
dr_gg        = where(ismissing(mask1C),dr_gg@_FillValue,dr_gg)
dr_gg        = where(dr_gg.eq.0,dr_gg@_FillValue,dr_gg)

perhw_concur_gg = 100*(hd_gg/hw_gg)
perdr_concur_gg = 100*(hd_gg/dr_gg)
perhw_concur    = dim_avg_n_Wrap(perhw_concur_gg,0)
perdr_concur    = dim_avg_n_Wrap(perdr_concur_gg,0)
copy_VarCoords(hw_count_gg,hw_gg)
copy_VarCoords(hw_count_gg,dr_gg)
copy_VarCoords(hw_count_gg,tmax_hd_gg)
copy_VarCoords(hw_count_gg,drght_hd_gg)
copy_VarCoords(hw_count_gg,perhw_concur_gg)
copy_VarCoords(hw_count_gg,perdr_concur_gg)
lat1 = 24
lat2 = 53

lon1 = 235
lon2 = 295

do gg                       = 0,dimsizes(gcm)-1
dataname1                   = gcm(gg)
fileout                     = "heatmap_stats_"+hw_thresh+"_"+hw_length_thresh+"_"+drght_indx+"_"+drght_ints+"_"+drght_dur+"_"+dataname1+".1deg.nc" 
system("rm "+fileout)
f2out                       =  addfile(fileout,"c")
f2out->hw_daycount          = hw_gg(gg,{lat1:lat2},{lon1:lon2})
f2out->drght_daycount       = dr_gg(gg,{lat1:lat2},{lon1:lon2})
f2out->hw_ints              = tmax_hd_gg(gg,{lat1:lat2},{lon1:lon2})
f2out->drght_ints           = drght_hd_gg(gg,{lat1:lat2},{lon1:lon2})
f2out->per_hwdays_concur    = perhw_concur_gg(gg,{lat1:lat2},{lon1:lon2})
f2out->per_drghtdays_concur = perdr_concur_gg(gg,{lat1:lat2},{lon1:lon2})
end do


end
